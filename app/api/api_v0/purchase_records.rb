module ApiV0
  class PurchaseRecords < Grape::API
    resource :user do

      params do
        requires :pay_by, type: String
      end
      post "/purchase-courses/:id" do
        authenticate!
        unless current_user
          status 403
          return { error: 'forbidden' }
        end

        Course.transaction do 
          course = Course.find(params[:id])
          unless course.try(:available)
            status 404
            return { error: 'not found' }
          end

          records = PurchaseRecord.joins(:course).includes(:course).
            where("user_id = ?", current_user.id).
            where("course_id = ?", params[:id]).
            where("expired_at >= ?", Time.now.utc)

          if records.count > 0
            status 403
            return { error: 'already buy' }
          end

          newPurchase = PurchaseRecord.new(
            :user_id => current_user.id, :course_id => params[:id],
            :pay_by => params[:pay_by], :expired_at => Time.now.utc + course.expiration)
          if newPurchase.save
            return newPurchase
          else
            raise StandardError, $!
          end
        end
      end
    end # resource end
  end
end
