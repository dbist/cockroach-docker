class EndangeredController < ApplicationController
  before_action :set_endangered, only: [:index, :data]

  def index
    if @endangered.length > 0
      redirect_to endangered_data_path
    else
      render 'index'
    end
  end

  def data
  end

  def upload
    csv_file = File.join Rails.root, 'db', 'sharks.csv'
    AddEndangeredWorker.perform_async(csv_file)
    redirect_to endangered_data_path, notice: 'Endangered sharks have been uploaded!'
  end

  def destroy
    RemoveEndangeredWorker.perform_async
    redirect_to root_path
  end

  private

    def set_endangered
      @endangered = Endangered.all 
    end

end
