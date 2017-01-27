class ChargesController < ApplicationController
  before_action :is_logged_in, :except => :update_sub

  protect_from_forgery :except => [:update_sub]

  def new

  end

  def create
    customer = Stripe::Customer.create(:email => params[:stripeEmail],
                                       :source => params[:stripeToken],
                                       plan: 'monthly')
    current_user.update_membership true
    current_user.update_attribute(:stripe_cus_id, customer.id)

  rescue Stripe::CardError => e
    current_user.update_membership false
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def update_sub
    begin
      event_json = JSON.parse(request.body.read)
      event_object = event_json['data']['object']
      #refer event types here https://stripe.com/docs/api#event_types
      case event_json['type']
        when 'invoice.payment_succeeded'
          User.find_by_stripe_cus_id(event_object['customer'])
              .update_membership(true)
        when 'invoice.payment_failed'
          User.find_by_stripe_cus_id(event_object['customer'])
              .update_membership(false)
        when 'charge.failed'
          User.find_by_stripe_cus_id(event_object['customer'])
              .update_membership(false)
        when 'customer.subscription.deleted'
          User.find_by_stripe_cus_id(event_object['customer'])
              .update_membership(false)
        when 'customer.subscription.updated'
      end
    rescue Exception => ex
      render :json => {:status => 422, :error => 'Webhook failed'}
      return
    end
    render :json => {:status => 200}
  end

  private

  def is_logged_in
    if !logged_in?
      redirect_to root_url
    end
  end

end
