function hh = ciJDB(x, y)

%tee = (max(y(:))-min(y(:)))/100; % make tee .02 x-distance for error bars
[n,npt] = size(x)
tee = 0;
xl = x - tee;
xr = x + tee;
%ytop = y + u;
%ybot = y - l;
ybot = y(1,:);
ytop = y(2,:);

% build up nan-separated vector for bars
xb = zeros(npt*9,n);
xb(1:9:end,:) = x;
xb(2:9:end,:) = x;
xb(3:9:end,:) = NaN;
xb(4:9:end,:) = xl;
xb(5:9:end,:) = xr;
xb(6:9:end,:) = NaN;
xb(7:9:end,:) = xl;
xb(8:9:end,:) = xr;
xb(9:9:end,:) = NaN;

yb = zeros(npt*9,n);
yb(1:9:end,:) = ytop;
yb(2:9:end,:) = ybot;
yb(3:9:end,:) = NaN;
yb(4:9:end,:) = ytop;
yb(5:9:end,:) = ytop;
yb(6:9:end,:) = NaN;
yb(7:9:end,:) = ybot;
yb(8:9:end,:) = ybot;
yb(9:9:end,:) = NaN;


symbol = '-';
[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

%h = plot(xb,yb,esymbol); hold on
h = plot(xb,yb,esymbol,'Color',[.8 .8 .8]); hold on
%h = [h;plot(x,y,symbol)];

%if ~hold_state, hold off; end
if nargout>0, hh = h; end
