function [ clusterName ] = getClusterName( cluster, addresses )
%name the cluster

%point order by importance
pointTypes = 'stop ground market bazar bazaar park college hospital chok chowk  adda ada stop road kutchery park mandi bazar bazaar club clubb tower center masjid signal bagh baagh ground block mosque school plaza  colony  town ';

pointTypes = strread(pointTypes,'%s');
numberPointTypes = length(pointTypes);
clusterName = '';
numAddresses = length(addresses);

nameAssigned = false;
numTotalTerms = 0;


tokens = '';
tokenIndex = 1;
freqMatrix = [];

%construct list of all tokens
%{
for i = 1:numAddresses
    currentAddress = strread(addresses{i},'%s');
    for j = 1:length(currentAddress)
           tokenIndex = find(ismember(tokens,currentAddress(j)));
            sizeIndex = size(tokenIndex);
         %this term does not exist already)
         if (sizeIndex(2) == 0)
                tokens{length(tokens)+1} = currentAddress{j};
                freqMatrix(length(tokens)+1,i) = 1;
         else
                freqMatrix(tokenIndex,i) =  1;
         end

    end
end

if (numAddresses > 10)
    a = 9;
end
%}

for k = 1:numberPointTypes
    for i = 1:numAddresses
        if (nameAssigned)
            break;
        end
        currentAddress = strread(addresses{i},'%s');
        for t = 1:length(currentAddress)
            if (nameAssigned)
                break;
            end
            currentAddressToken = currentAddress(t);
            if (strcmpi(currentAddressToken,pointTypes(k)) == 1)
                    for p = 1:t
                        clusterName = strcat(clusterName,{' '},currentAddress(p));
                    end
                    clusterName = clusterName{1};
                    nameAssigned = true;
            break;
            end
        end
    end
end
