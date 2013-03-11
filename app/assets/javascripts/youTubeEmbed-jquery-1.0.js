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
			
			// make it always 9/16?
			//settings.ratio = 3/4; //was kda
			settings.ratio=9/16;
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
				height	: correct_height +32 //settings.height
			}}).appendTo(elements.originalDIV);

			// Embedding the YouTube chromeless player
			// and loading the video inside it:
			
			
//http://www.youtube.com/v/VIDEO_ID?version=3&enablejsapi=1
//'http://www.youtube.com/apiplayer?enablejsapi=1&version=3'
			elements.container.flash({
				swf			: 'http://www.youtube.com/v/'+settings.videoID+'?version=3&enablejsapi=1&rel=0&showinfo=0&autohide=0&fs=0',
				id			: 'video_'+settings.safeID,
				height		: correct_height + 32,
				width		: settings.width,
				duration	: data.duration,
				allowScriptAccess:'always',
				allowFullScreen: false,
				wmode		: 'opaque',
				flashvars	: {
					"video_id"		: settings.videoID,
					"playerapiid"	: settings.safeID,
					"fs":0
					
				},
				
			});

			// We use get, because we need the DOM element
			// itself, and not a jquery object:
			
			elements.player = elements.container.flash().get(0);
			console.log("plaer is"+elements.player)
			// Creating the control Div. It will act as a ply/pause button

			//var timer=  $('<div>',{"class":'timer',"style":"width:"+width+"px","id":"timer_video_"+haveid}).appendTo(elements.container);
			elements.control = $('<div>',{"class":'controlDiv play',"style":"display:none;"})
							   .appendTo(elements.container.parent());
             if(type=="small"){
             var fullScreen=  $('<div>',{"class":'fullscreenDiv full'}).appendTo(elements.container);
             }
             else{
             var fullScreen=  $('<div>',{"class":'fullscreenDiv small'}).appendTo(elements.container);	
             }            
             var confused=  $('<div>',{"class":'confusedDiv', "onclick":"confused('video_"+haveid+"')"}).appendTo(elements.container);
             var question=  $('<div>',{"class":'questionDiv', "onclick":"fading('video_"+haveid+"')"}).appendTo(elements.container);
             var shortcuts=  $('<div>',{"class":'shortcutDiv', "onclick":"shortcuts('video_"+haveid+"')"}).appendTo(elements.container);
             
             var highlight=  $('<div>',{"class":'highlight_play'}).appendTo(elements.container);
             // for the question
             var hidden_div= $('<div>',{"id":"conf_video_"+haveid,"style":'display:none;',"class":"hidden_div"}).appendTo(elements.container);
             var hidden_input= $('<input>',{"type":'text', "id":"confusedQues_video_"+haveid, "placeholder":"Enter Question", "style":"margin-top:15px;margin-bottom:3px;line-height:10px;font-size:10px;width:150px;height:13px;", "name":"confusedQues", "required":"true"}).appendTo(hidden_div);
             var hidden_button= $('<input>',{"type":"button", "onclick":"confusedQuestion('video_"+haveid+"')", "class":"btn btn-primary", "style":"height:25px;margin-bottom:-12px;line-height:10px;font-size:10px;","value":"Ask"}).appendTo(hidden_div);
            
             
             var hidden_shortcuts= $('<div>',{"id":"short_video_"+haveid,"style":'display:none',"class":"well hidden_shortcuts"}).appendTo(elements.container);
             
             // for confused notification
             var confused_notif = $('<div>',{"id":"confused_notify_video_"+haveid, "class":"confused_notif"}).appendTo(elements.container);
             
             // change duration:
             $('#dur').html(formatSecondsAsTime(data.duration))
             
             //$('#timer_video_'+haveid).html("<p style='float:left;margin-left:60px;left:50px;line-height:60px;color:gray'>"+formatSecondsAsTime(0) +"</p> <p style='float:left;margin-left:0px;line-height:60px;color:gray'> / "+formatSecondsAsTime(data.duration)+"</p>");
             
             // $('#f_screen').click(function(event){
	             	// resize();
             // });
             
               window.onresize=function resizeit(){
						// check if full screen first.
						if($("#page").css("position")=="fixed")
							resize();
					// also if there are buttons should place them correctly.
					// play by default when enter page.
				};
			
			
			
			resize = function()
			{
					//var x=$("body").offset();
					//$(".container").offset();
					//$(".content").offset();
					//$("#player").css(x)
					//$(window).width();
					//$(window).height();
					
					
					$("#video_youVideo").css("margin-left", "0px");
					$("#ontop_video_youVideo").css("margin-left", "0px");
						
					$("body").css("overflow","hidden"); //return
					$("#page").css("position","fixed"); //return
					$("#page").css({"top":0,"left":0});
					$("#page").css({"margin-top":"0px"});
					
					//$("#timer_video_youVideo").width($(window).width());
					$("#ontop_video_youVideo").css("z-index",1050);
					$("#ontop_video_youVideo").css("margin-top","0px");
					$("#video_youVideo").css("margin-top", "0px");
					$("#player").width($(window).width());
					$("#page").width($(window).width());
					$("#page").css("z-index",1035);
					$("#player").css("z-index",1040);
					$(".flashContainer").width($(window).width());
					$(".flashContainer").css("margin","0px");  //default 40px auto
					$(".flashContainer").css("background-color","black"); 
					
					
					
					$("#page").height($(window).height());
					$("#player").height($(window).height());
					$("#ontop_video_youVideo").height($(window).height()-33); //-50 for control bar
					$(".flashContainer").height($(window).height());
					$("#video_youVideo").height($(window).height());
					
					
					var hv=$(window).height()-32
					// setting width of ontop and video depending on the height
					
					$("#video_youVideo").width($(window).width());
					$("#ontop_video_youVideo").width((hv-1)*16.0/9.0);
					
					if($("#ontop_video_youVideo").width()>$(window).width())  // if width will get cut out.
					{
						//$("#video_youVideo").width($(window).width());
						$("#ontop_video_youVideo").width($(window).width());
						//$("#video_youVideo").height($(window).width()*9.0/16.0 + 32);
						$("#ontop_video_youVideo").height($(window).width()*9.0/16.0);
						
						var lf= ($(".flashContainer").height() -32 - $("#ontop_video_youVideo").height())/2.0;
						//$("#video_youVideo").css("margin-top", lf+"px");
						$("#ontop_video_youVideo").css("margin-top", lf+"px");
						
					}
					else{
						
					var lf= ($(".flashContainer").width() - ($("#video_youVideo").height()-32)*16.0/9.0)/2.0;
					//$("#video_youVideo").css("margin-left", lf+"px");
					$("#ontop_video_youVideo").css("margin-left", lf+"px");
					}
					
					
					
					
					// if there is a quiz right now
					if(flag==1)
					{
						for(var i=0; i<list_of_points.length; i++)
						{
							var toadd= $("#"+list_of_points[i][0])
							var top3= parseFloat((list_of_points[i][2])*$("#ontop_video_youVideo").height());
							var left= parseFloat((list_of_points[i][1])*$("#ontop_video_youVideo").width())+(4/800.0 * $("#ontop_video_youVideo").width());
							toadd.css({"top":top3+"px", "left":left+"px"});
						}
					}
					
					// take care of ontop, correct aspect ratio, background..position., and correct point position
					// on resize, make small again, get fullscreen and minimize button working.
					// make sure progress bar working right..
					// make player page and flash entire size but video correct aspect ratio.
					//$("#timer_video_youVideo").height($(window).height());
					
					// ok so when display points, display fil makan el sa7 AND when they are there already and we're resizing.
					// play by default when enter page.
					// but before kol da store points aslan as %
			}
             
             
             $('.fullscreenDiv.full').click(function(){
				//alert("i was clicked");
				// console.log(url)
				// if(first==1)
				// {
				// $('#player2').youTubeEmbed(url, 832,520,'big','bigVideo');
				// first=0;
				// }
                // $('#myModal2').modal('show')
                $(this).removeClass("full");
                $(this).addClass("small");
                
            	$('.fullscreenDiv.small').unbind();
            	bind_small();	    
                
                resize();
			});
			
			
			bind_small=function(){
			$('.fullscreenDiv.small').click(function(){
				// //alert("i was clicked");
				// $('#myModal2').modal('hide')
				// elements.player.pauseVideo();
				
					$(this).removeClass("small");
                	$(this).addClass("full");
				
					$("body").css("overflow","auto"); //return
					$("#page").css("position","static"); //return
					//$("#page").css({"top":0,"left":0});
					
					
     
        
					//$("#timer_video_youVideo").width(800);
					$("#ontop_video_youVideo").css("z-index",2);
					$("#ontop_video_youVideo").css("margin-top","40px");
					$("#player").width(800);
					$("#page").width(800);
					$("#player").css("z-index",0);
					$("#page").css("z-index",0);
					$("#page").css({"margin-top":"-40px"});
					$(".flashContainer").width(800);
					$(".flashContainer").css("margin","40px auto");  //default 40px auto
					$(".flashContainer").css("background-color","black"); 
					
					
					
					$("#page").height(600);
					$("#player").height(500);
					$("#ontop_video_youVideo").height(448); //-50 for control bar
					$(".flashContainer").height(450+32);
					$("#video_youVideo").height(450+32);
					
					$("#video_youVideo").width(800);
					$("#ontop_video_youVideo").width(800);
					
					
					$("#video_youVideo").css("margin-left", "0px");
					$("#ontop_video_youVideo").css("margin-left", "0px");
					
					$("#video_youVideo").css("margin-top", "0px");
					
				
					if(flag==1)
					{
						for(var i=0; i<list_of_points.length; i++)
						{
							var toadd= $("#"+list_of_points[i][0])
							var top3= parseFloat((list_of_points[i][2])*$("#ontop_video_youVideo").height());
							var left= parseFloat((list_of_points[i][1])*$("#ontop_video_youVideo").width())+ (4/800.0 * $("#ontop_video_youVideo").width());
							toadd.css({"top":top3+"px", "left":left+"px"});
						}
					}
				
					$('.fullscreenDiv.full').unbind();
            		$('.fullscreenDiv.full').click(function(){
						//alert("i was clicked");
						// console.log(url)
						// if(first==1)
						// {
						// $('#player2').youTubeEmbed(url, 832,520,'big','bigVideo');
						// first=0;
						// }
		                // $('#myModal2').modal('show')
		                $(this).removeClass("full");
		                $(this).addClass("small");
		                
		            	$('.fullscreenDiv.small').unbind();
		            	bind_small();	    
		                
		                resize();
					});	
				
			})};
			
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
				elements.progress =	$('<div>',{"class":'progressBar',"style":"display:none"})
									.appendTo(elements.container.parent());

				elements.elapsed =	$('<div>',{"class":'elapsed',"style":"display:none"})
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
			paused=false;
			buffering=false;
            
			// Creating a global event listening function for the video
			// (required by YouTube's player API):
			
			window['eventListener_'+settings.safeID] = function(status){  //onstatechange
 				console.log("time is "+ elements.player.getCurrentTime());
				var interval;
						
				
				console.log(elements.player.getPlayerState());
				
				if(elements.player.getPlayerState()==1){
								
								remove_lecture_buttons();
								
								// If the video is not currently playing, start it:
								buffering=false;
								paused=false;
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
								// here if paused
								console.log("in pause")
								
								// If the video is currently playing, pause it:
								if(buffering!=true && paused==false){
									console.log("inside method");
									pause(elements.player.getCurrentTime());
								}
								elements.control.removeClass('pause').addClass('play');
								elements.container.removeClass('playing');
								//elements.player.pauseVideo();
								buffering=false
								paused=true
								if(settings.progressBar){
									window.clearInterval(interval);
								}
							}else if(elements.player.getPlayerState()==3){ //buffering
								// here if paused
								buffering=true;
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
					add_lecture_buttons();
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
                    console.log("int is "+interval);
                    
                    //console.log("cuureent "+('video_'+playerID).getCurrentTime());
                    document.getElementById('video_'+playerID).playVideo();
                   
                    //set quality
                    document.getElementById('video_'+playerID).setPlaybackQuality("large"); // could make it default.. to change dynamically based on user capabilities.
                    
                    document.getElementById('video_'+playerID).addEventListener('onStateChange','eventListener_'+playerID);
                    
                    
                    
				}
                //console.log(('video_'+playerID).getCurrentTime());
//                var interval = window.setInterval(function() { checkTime(); }, 100);
//                console.log(interval);
                    
			}
		},'jsonp');

		return elements.originalDIV;
	}

})(jQuery);