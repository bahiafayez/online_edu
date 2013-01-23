ActiveAdmin.register User do
  actions :all, :except => [:new]
  
  filter :email
  filter :name
  filter :roles_id, collection: proc { Role.where(:name => ["admin","user"]) }, :as => :check_boxes
  #filter :associated_role_id, :as => :check_boxes, :collection => proc { Role.all }
  
  #member_action :roles do
    # your normal action code
  #  User.find(params[:id])
  #  redirect_to(:user)
  #end
  
 # action_item :only => :show do
 #     link_to "Change Role", "/"
 # end
  
  index do
    column "Id" do |user|
      link_to user.id, admin_user_path(user)
    end
    column :email
    column :name
    column "Role" do |user|
      if !user.roles.empty?
      puts user.roles.first.name
        if user.roles.first.name=="user"
        "Student" 
       elsif user.roles.first.name=="admin"
         "Teacher"
       end
       end
      
    end
    
    default_actions
   # column "Change Role" do |user|
   #   link_to "Change Role", "/" 
   # end
    
  end
  
  
  form do |f|
        f.inputs "Profile Information" do
            f.input :email
            f.input :name
        end
        f.inputs :name => "Role" do
            f.input :role_ids, :as => :select,:collection => Role.where(:name => ["admin","user"])
        end
        f.buttons
    end
    
    
    show :title => :name do |user|
      attributes_table do
        row :id
        row :name
        row :email
        row :Role do
          Role.find(user.role_ids.first)
        end
        row :encrypted_password
        row :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        
      end
      active_admin_comments

    end
end
