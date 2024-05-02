module ApplicationHelper
    def flash_class(type)
        case type
        when 'alert'
          'text-red-600' # 紅色
        when 'notice'
          'text-blue-600' # 藍色
        else
          'text-black' # 預設黑色
        end
    end
end
