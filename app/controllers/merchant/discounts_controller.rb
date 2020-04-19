class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    merchant = Merchant.find(current_user.merchant_id)
    @discount = merchant.discounts.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      flash[:success] = "Your new discount has been added."
      redirect_to merchant_discounts_path
    else
      flash.now[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params[:discount].permit(:name, :threshold, :percent_off)
  end

end