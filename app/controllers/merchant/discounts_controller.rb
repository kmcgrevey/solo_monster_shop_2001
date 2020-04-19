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

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      # flash[:success] = "Item information has been updated!"
      redirect_to merchant_discount_path(discount)
    # else
    #   flash[:error] = item.errors.full_messages.to_sentence
    #   redirect_back(fallback_location: "/")
    end
  end

  private

  def discount_params
    params[:discount].permit(:name, :threshold, :percent_off)
  end

end