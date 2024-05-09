module ApplicationHelper
    def flash_class(type)
        case type
        when 'alert'
          'absolute top-0 w-full px-4 py-3 rounded border bg-red-100  border-red-400 text-red-700' # 紅色
        when 'notice'
          'absolute top-0 w-full px-4 py-3 rounded border bg-blue-100  border-blue-400 text-blue-700' # 藍色
        else
          'absolute top-0 w-full px-4 py-3 rounded border bg-slate-100  border-slate-400 text-slate-700' # 預設灰
        end
    end
end
