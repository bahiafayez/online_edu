(function($){
	
	var first=1;
	
	$.fn.youTubeEmbed = function(settings, width, height,type, haveid){
		
		// Settings can be either a URL string,
		// or an object
		var url=settings;
		
		
		if(typeof settings == 'string'){
			settings = {'video' : settings}
		}
		
		// Default values
		
		var def = {
			width		: width,
            height      : height,
			progressBar	: true
		};
		
		settings = $.extend(def,settings);
		
		var elements = {
			originalDIV	: this,	// The "this" of the plugin
			container	: null,	// A container div, inserted by the plugin
			control		: null,	// The control play/pause button
			player		: null,	// The flash player
			progress	: null,	// Progress bar
			elapsed		: null	// The light blue elapsed bar
		};
		

		try{	

			settings.videoID = settings.video.match(/v=(.{11})/)[1];
			
			// The safeID is a stripped version of the
			// videoID, ready for use as a function name

			settings.safeID = haveid//settings.videoID.replace(/[^a-z0-9]/ig,'');
		
		} catch (e){
			// If the url was invalid, just return the "this"
			return elements.originalDIV;
		}

		// Fetch data about the video from YouTube's API

		var youtubeAPI = "http://gdata.youtube.com/feeds/api/videos/"+settings.videoID+"?v=2&alt=jsonc";

		$.get(youtubeAPI,function(response){
			
			var data = response.data;
	
		//	if(!data.totalItems || data.items[0].accessControl.embed!="allowed"){
				
				// If the video was not found, or embedding is not allowed;
	//			console.log("no permission")
	//			return elements.originalDIV;
	//		}

			// data holds API info about the video:
			
			//data = data.items[0];
			
			settings.ratio = 3/4;
			if(data.aspectRatio == "widescreen"){
				settings.ratio = 9/16;
			}
			
            // uncomment this line to automatically calculate height.
			//settings.height = Math.round(settings.width*settings.ratio);
			var correct_height = Math.round(settings.width*settings.ratio);

			// Creating a container inside the original div, which will
			// hold the object/embed code of the video

			elements.container = $('<div>',{"class":'flashContainer',css:{
				width	: settings.width,
				height	: settings.height
			}}).appendTo(elements.originalDIV);

			// Embedding the YouTube chromeless player
			// and loading the video inside it:
			
			

			elements.container.flash({
				swf			: 'http://www.youtube.com/apiplayer?enablejsapi=1&version=3',
				id			: 'video_'+settings.safeID,
				height		: correct_height,
				width		: settings.width,
				duration	: data.duration,
				allowScriptAccess:'always',
				wmode		: 'transparent',
				flashvars	: {
					"video_id"		: settings.videoID,
					"playerapiid"	: settings.safeID
				}
			});

			// We use get, because we need the DOM element
			// itself, and not a jquery object:
			
			elements.player = elements.container.flash().get(0);
			console.log(elements.player)
			// Creating the control Div. It will act as a ply/pause button

			var timer=  $('<div>',{"class":'timer',"style":"width:"+width+"px","id":"timer_video_"+haveid}).appendTo(elements.container);
			elements.control = $('<div>',{"class":'controlDiv play'})
							   .appendTo(elements.container);
             if(type=="small"){
             var fullScreen=  $('<div>',{"class":'fullscreenDiv full'}).appendTo(elements.container);
             }
             else{
             var fullScreen=  $('<div>',{"class":'fullscreenDiv small'}).appendTo(elements.container);	
             }            
             var confused=  $('<div>',{"class":'confusedDiv', "onclick":"confused('video_"+haveid+"')"}).appendTo(elements.container);
             var question=  $('<div>',{"class":'questionDiv', "onclick":"fading('video_"+haveid+"')"}).appendTo(elements.container);
             var shortcuts=  $('<div>',{"class":'shortcutDiv', "onclick":"shortcuts('video_"+haveid+"')"}).appendTo(elements.container);
             
             // for the question
             var hidden_div= $('<div>',{"id":"conf_video_"+haveid,"style":'display:none;',"class":"hidden_div"}).appendTo(elements.container);
             var hidden_input= $('<input>',{"type":'text', "id":"confusedQues_video_"+haveid, "placeholder":"Enter Question", "style":"margin-top:8px;width:150px;height:15px;", "name":"confusedQues", "required":"true"}).appendTo(hidden_div);
             var hidden_button= $('<input>',{"type":"button", "onclick":"confusedQuestion('video_"+haveid+"')", "class":"btn btn-primary", "style":"height:25px;margin-bottom:2px","value":"Ask"}).appendTo(hidden_div);
            
             
             var hidden_shortcuts= $('<div>',{"id":"short_video_"+haveid,"style":'display:none',"class":"well hidden_shortcuts"}).appendTo(elements.container);
             
             // for confused notification
             var confused_notif = $('<div>',{"id":"confused_notify_video_"+haveid, "class":"confused_notif"}).appendTo(elements.container);
             
             // change duration:
             $('#dur').html(formatSecondsAsTime(data.duration))
             
             $('#timer_video_'+haveid).html("<p style='float:left;margin-left:60px;left:50px;line-height:60px;color:gray'>"+formatSecondsAsTime(0) +"</p> <p style='float:left;margin-left:0px;line-height:60px;color:gray'> / "+formatSecondsAsTime(data.duration)+"</p>");
             
             $('.fullscreenDiv.full').click(function(){
				//alert("i was clicked");
				console.log(url)
				if(first==1)
				{
				$('#player2').youTubeEmbed(url, 832,520,'big','bigVideo');
				first=0;
				}
                $('#myModal2').modal('show')
			})
			
			$('.fullscreenDiv.small').click(function(){
				//alert("i was clicked");
				$('#myModal2').modal('hide')
				elements.player.pauseVideo();
			})
			
			$("#confusedQues_video_"+haveid).bind('keyup', function(e) {

   						 if ( e.keyCode === 13 ) { // 13 is enter key

        					confusedQuestion('video_'+haveid)

    				}
			});


           // fullScreen.click(function(){
                //alert("I was clicked"+ elements.container.width(300));
                //console.log(elements.container.flash().width(300))
           //     $('#player2').youTubeEmbed("http://www.youtube.com/watch?v=0NcJ_63z-mA", 1000,800);
           //     $('#myModal').modal('toggle')
           // });
            
            // setting quality.
            
			////// adding shortcuts //////
			
			//////////////////////////////


			// If the user wants to show the progress bar:

			if(settings.progressBar){
				elements.progress =	$('<div>',{"class":'progressBar'})
									.appendTo(elements.container);

				elements.elapsed =	$('<div>',{"class":'elapsed'})
									.appendTo(elements.progress);
				
				elements.progress.click(function(e){
					
					// When a click occurs on the progress bar, seek to the
					// appropriate moment of the video.
					
					var ratio = (e.pageX-elements.progress.offset().left)/elements.progress.outerWidth();
					
					elements.elapsed.width(ratio*100+'%');
					elements.player.seekTo(Math.round(data.duration*ratio), true);
					return false;
				});

			}


           

			var initialized = false;
			
            
			// Creating a global event listening function for the video
			// (required by YouTube's player API):
			
			window['eventListener_'+settings.safeID] = function(status){
 console.log("time is "+ elements.player.getCurrentTime());
				var interval;
						
				
				console.log(elements.player.getPlayerState());
				
				if(elements.player.getPlayerState()==1){
								
								// If the video is not currently playing, start it:

								elements.control.removeClass('play replay').addClass('pause');
								elements.container.addClass('playing');
								//elements.player.playVideo();
								
								if(settings.progressBar){
									interval = window.setInterval(function(){
										elements.elapsed.width(
											((elements.player.getCurrentTime()/data.duration)*100)+'%'
										);
									},1000);
								}
								
							} else if(elements.player.getPlayerState()==2){ 
								
								// If the video is currently playing, pause it:
								
								elements.control.removeClass('pause').addClass('play');
								elements.container.removeClass('playing');
								//elements.player.pauseVideo();
								
								if(settings.progressBar){
									window.clearInterval(interval);
								}
							}
							
				
				if(status==-1)	// video is loaded
				{
                console.log("time is "+ elements.player.getCurrentTime());
                
                
					if(!initialized)
					{
						// Listen for a click on the control button:
						
						elements.control.click(function(){
							if(!elements.container.hasClass('playing')){
								
								// If the video is not currently playing, start it:

								elements.control.removeClass('play replay').addClass('pause');
								elements.container.addClass('playing');
								elements.player.playVideo();
								
								if(settings.progressBar){
									interval = window.setInterval(function(){
										elements.elapsed.width(
											((elements.player.getCurrentTime()/data.duration)*100)+'%'
										);
									},1000);
								}
								
							} else {
								
								// If the video is currently playing, pause it:
								
								elements.control.removeClass('pause').addClass('play');
								elements.container.removeClass('playing');
								elements.player.pauseVideo();
								pause(elements.player.getCurrentTime());
								
								if(settings.progressBar){
									window.clearInterval(interval);
								}
							}
						});
						
						initialized = true;
					}
					else{
						// This will happen if the user has clicked on the
						// YouTube logo and has been redirected to youtube.com

						if(elements.container.hasClass('playing'))
						{
							elements.control.click();
						}
					}
				}
				
				if(status==0){ // video has ended
					elements.control.removeClass('pause').addClass('replay');
					elements.container.removeClass('playing');
					//showEvaluation(settings.safeID);  .. khaleto mawgoud 3ala tool.
				}
			}
			
			// This global function is called when the player is loaded.
			// It is shared by all the videos on the page:
			
			if(!window.onYouTubePlayerReady)
			{				
				window.onYouTubePlayerReady = function(playerID){
					
                    //var interval = window.setInterval(function() { checkTime(); }, 1000);
                    //console.log(interval);
                     var interval = window.setInterval(function() { checkTime('video_'+playerID, $(document.getElementById('video_'+playerID)).children("param[name='duration']:first").val()); }, 100);
                    console.log(interval);
                    
                   
                    //set quality
                    document.getElementById('video_'+playerID).setPlaybackQuality("large"); // could make it default.. to change dynamically based on user capabilities.
                    
                    document.getElementById('video_'+playerID).addEventListener('onStateChange','eventListener_'+playerID);
                    console.log(('video_'+playerID).getCurrentTime());
                    
                    
				}
                //console.log(('video_'+playerID).getCurrentTime());
//                var interval = window.setInterval(function() { checkTime(); }, 100);
//                console.log(interval);
                    
			}
		},'jsonp');

		return elements.originalDIV;
	}

})(jQuery);