
% --- Set coefficients here --- %
an = @(n) 0;
bn = @(n) 4/(pi*n);
a0 = 0;
T0 = 1;
% ----------------------------- %

% --- Set other parameters here --- %
terms = 100; % Number of terms to use in the series
startOfSeries = 1; % Where to start n
termsToJump = 2; % n counts up by this number
% --------------------------------- %


oddFunc = @(x) bn(x(1)) * sin(x(1)*pi*x(2)/T0);
evenFunc = @(x) an(x(1)) * cos(x(1)*pi*x(2)/T0);

t = linspace(-2*T0, 2*T0, 401);
f = ones(401,1)*a0/2;
ftemp = zeros(401,1);

for i = startOfSeries:termsToJump:terms*termsToJump
    for j = 1:length(t)
        ftemp(j) = oddFunc([i,t(j)]);
    end
    f = f + ftemp;
    
    for j = 1:length(t)
        ftemp(j) = evenFunc([i,t(j)]);
    end
    f = f + ftemp;
end

plot(t,f)