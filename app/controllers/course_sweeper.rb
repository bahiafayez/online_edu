class CourseSweeper < ActionController::Caching::Sweeper
  observe Course # This sweeper is going to keep an eye on the Product model
 
  # If our sweeper detects that a Product was created call this
  def after_create(course)
    #expire_cache_for(course)
  end
 
  # If our sweeper detects that a Product was updated call this
  def after_update(course)
    #expire_cache_for(course)
    #expire_cache_for_show(course)
    #expire_fragment(:controller => 'courses', :action => 'show', :id => course.id)
    #expire_fragment(:controller => 'courses', :action => 'edit', :id => course.id)
    #expire_fragment(:controller => 'courses', :action => 'student_show', :id => course.id)
  end
 
  # If our sweeper detects that a Product was deleted call this
  def after_destroy(course)
    #expire_cache_for(course)
    #expire_fragment(:controller => 'courses', :action => 'show', :id => course.id)
    #expire_fragment(:controller => 'courses', :action => 'edit', :id => course.id)
    #expire_fragment(:controller => 'courses', :action => 'course_editor', :id => course.id)
    #expire_fragment(:controller => 'courses', :action => 'student_show', :id => course.id)
    #expire_fragment(:controller => 'courses', :action => 'courseware', :id => course.id)
  end
 
  private
  # def expire_cache_for(course)
    # # Expire the index page now that we added a new product
    # expire_action(:controller => 'courses', :action => 'index')
#  
    # # Expire a fragment
    # #expire_fragment('all_available_products')
  # end
end