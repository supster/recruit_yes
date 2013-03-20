module ApplicationHelper

  def full_title(page_title)
    base_title = 'Recruit Yes'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end      
  end
  
  def show_text(obj)
    if obj.nil?
      ""
    else 
      obj.text
    end
    
  end
 
end