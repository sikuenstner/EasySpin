function [err,data] = test(opt,olddata)

Pulse.Type = 'sech/uniformQ';  

Pulse.beta = 10;
Pulse.n = [6 6];


Exp.t = [0.1 0.5 0.1];
Exp.Pulses = {Pulse 0 Pulse};
Exp.Field = 1240; 
Exp.TimeStep = 0.0001; % us
Exp.Frequency = [0.95 1.05];
Exp.Flip = [pi pi];
Exp.DetEvents = 1;

% First Syntax -----------------------------
Exp.nPoints = 3;
Exp.Dim = {'p1.n(2)' -2};

Opt = struct('unused',NaN);

[~, Vary1] = runprivate2('s_sequencer',Exp,Opt);

Seq1IQs = Vary1.Pulses{1}.IQs;

% Second Syntax -----------------------------
Exp.Dim = {'p1.n(2)' [-2 -4]};

[~, Vary2] = runprivate2('s_sequencer',Exp,Opt);

Seq2IQs = Vary2.Pulses{1}.IQs;

Pulse.n = [6 6];
Pulse.TimeStep = 0.0001;
Pulse.tp = 0.1;
Pulse.Frequency = [0.95 1.05];
Pulse.Flip = pi;
% pulse(Pulse)

IQs = cell(1,Exp.nPoints);
for i = 1:3
  Pulse.n(2) = 6 - (i-1)*2;
  [~,IQs{i}] = pulse(Pulse);
end

if any([~isequal(IQs,Seq1IQs) ~isequal(IQs,Seq2IQs)])
  err = 1;
else
  err = 0;
end

data = [];