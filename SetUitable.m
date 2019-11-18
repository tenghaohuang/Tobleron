function [bool,handle,figure_handle] = SetUitable(data)
figure_handle=figure('Name','DataTable');
uitable_handle=uitable();
set(uitable_handle,'data',{});
set(uitable_handle,'data',data);
handle = uitable_handle;
bool =1;
end