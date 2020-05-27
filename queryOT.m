% query octree
function ti = queryOT(pos, OT)
binind = 1;
maxbiniter = 50;
biniter = 0;
while (1)
    if (biniter > maxbiniter)
        ti = 1;
        fprintf('No bin found...\n');
        break;
    end
    
    biniter = biniter + 1;
    currbin = binind;
    octind = 0;
    binc = OT.BinCentres(binind,:);
    
    if (pos(1)>=binc(1)); octind = bitor(octind,1); end
    if (pos(2)>=binc(2)); octind = bitor(octind,2); end
    if (pos(3)>=binc(3)); octind = bitor(octind,4); end
    
    has_children = OT.BinChildren(binind,1)>0;
    
    if (~has_children)
        ti = OT.BinChildren(currbin,2);
        break;
    end
    
    binind = OT.BinChildren(binind,octind+1);
end
end
