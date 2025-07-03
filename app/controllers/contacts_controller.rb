 class ContactsController < ApplicationController

  def index
    @contacts = Contact.all
  end
  def new
    @contacts = Contact.new
  end

  def create
    @contacts = Contact.new(contact_params)
    if @contacts.save
      flash[:notice] = "Merci pour votre message !"
      redirect_to root_path
    else
      flash.now[:alert] = "Une erreur est survenue."
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
