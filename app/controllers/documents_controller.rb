class DocumentsController < ApplicationController
 
  
  # PUT /online_quizzes/1
  # PUT /online_quizzes/1.json
  def update
    @document = Document.find(params[:id])
    @group= @document.group
    @course = @group.course
    #@lecture= @online_quiz.lecture
    puts "group isss #{@group}"
    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
        format.js{render "groups/new_document"}
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_quizzes/1
  # DELETE /online_quizzes/1.json
  def destroy
    @document = Document.find(params[:id])
    #@from_lecture=@online_quiz.lecture
    @document.destroy

    respond_to do |format|
      #format.html { redirect_to online_quizzes_url }
      format.json { head :no_content }
      format.js { render "delete", :locals => {:rem => params[:id]}}
    end
  end
end
