clear;

%phasenames = {'P','S','PP','PPP','PKIKP','SSS','SSSS','PKKP','PKKKP','PKIKKIKP'}
%phasenames = {'P','S','pP','sS','SS','SKS','ScS','SKKS','PcP'}
%phasenames = {'Pdiff','Sdiff','SP','PPPP','PSP','SSP'}
%phasenames = {'SKKKS','SKIKKIKS'}
%phasenames = {'SSP','PPSS'}
phasenames = {'pP','pS','sP','sS'};

if exist('phasedb.mat','file')
	load phasedb.mat
	exist_phase_names = [phases.name];
else
	phases = [];
	exist_phase_names = {};
end

for ip = 1:length(phasenames)
	if ismember(phasenames(ip),exist_phase_names)
		continue;
	end
	disp(char(phasenames(ip)));
	phases(end+1).name = phasenames(ip);
	system(['taup_table -model prem -ph ',char(phasenames(ip)),' | awk ''{print $2,$3,$5}'' > phasetemp.txt']);
	data = load('phasetemp.txt');
	evdp = data(:,2);
	depths = unique(evdp);
	for id = 1:length(depths)
		ind = find(evdp == depths(id));
		dist = data(ind,1);
		traveltime = data(ind,3);
		phases(end).event(id).time = traveltime;
		phases(end).event(id).dist = dist;
		phases(end).event(id).evdp = depths(id);
	end
	phases(end).evdps = depths;
end

save('phasedb.mat','phases');



