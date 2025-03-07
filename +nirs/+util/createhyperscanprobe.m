function probe = createhyperscanprobe(probeA,probeB)
% This function will create a hyperscanning probe by copying the parameters
% from a single probe

if(nargin==1)
    probeB=probeA;
end

probe=probeA;


Y=probeB.optodes.Y;
probeB.optodes.Y=probeB.optodes.Y-mean(Y);
probeShift=probe;

probeShift.optodes.Y = probeShift.optodes.Y+2.5*max(abs(Y));

s=find(ismember(probeShift.optodes.Type,'Source'));
for i=1:length(s)
    str=['000' num2str(i+size(probeA.srcPos,1))];
    probeShift.optodes.Name{s(i)}=['Source-' str(end-3:end)];
end
s=find(ismember(probeShift.optodes.Type,'Detector'));
for i=1:length(s)
    str=['000' num2str(i+size(probeA.detPos,1))];
    probeShift.optodes.Name{s(i)}=['Detector-' str(end-3:end)];
end


link=probeB.link;
if(isa(probeShift,'nirs.core.ProbeROI'))
    for i=1:height(link)
        link.ROI{i}=[link.ROI{i} 'b'];
    end
else
    if iscell(link.source)
        for i=1:height(link)
            link.source{i}=link.source{i}+size(probeA.srcPos,1);
            link.detector{i}=link.detector{i}+size(probeA.detPos,1);
        end
    else
        link.source=link.source+size(probeA.srcPos,1);
        link.detector=link.detector+size(probeA.detPos,1);
    end
end
probeShift.link=link;

hyperscan=repmat('A',height(probeA.link),1);
probe.link=[probe.link table(hyperscan)];

hyperscan=repmat('B',height(probeShift.link),1)
probeShift.link=[probeShift.link table(hyperscan)];

probe.link=[probe.link; probeShift.link];
probe.optodes=[probe.optodes; probeShift.optodes];