#encoding: UTF-8

class CladenameController < ApplicationController

  before_filter :requires_logged_in

  def check_homonym
    tem = params[:name].split(',')
    if tem.length == 1
      @homonym = GenericName.all(:conditions => ["name = ? ", params[:name]])
    else
      @homonym = GenericName.all(:conditions => ["name = ? and id != ?", tem[0],tem[1].to_i])
    end
    render :partial => "view_homonym"
  end

  def find_name
    names = Submission.where("name = ?", params[:id])
    render :json => names.to_json
  end
  
  def check_name
    names = Submission.where("name LIKE ?", "#{params[:id]}%")
    render :json => names.to_json
  end
end
