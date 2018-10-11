function listToUse = getCrimeList( crimes, crimeList, inputList )
%crime types is an array that contains crimetypes to group

if (crimes == 12345678910)
    listToUse = inputList;
else
    if (crimes == 910)
        listToUse = cat(1,inputList(crimeList == 9),inputList (crimeList == 10));
    else
        if (crimes == 1234)
            listToUse = cat(1,inputList(crimeList ==1),inputList(crimeList ==2),inputList(crimeList ==3), inputList(crimeList ==4));
        else
            if (crimes == 578)
                listToUse = cat(1,inputList(crimeList == 5),inputList(crimeList ==7),inputList(crimeList ==8));
            else
                if (crimes == 5678910)
                    listToUse = cat(1,inputList(crimeList == 5),inputList(crimeList ==6),inputList(crimeList ==7),inputList(crimeList ==8),inputList(crimeList ==9),inputList(crimeList ==10));
                else
                    listToUse = inputList(crimeList == crimes);
            
                end
                
            end
            
        end
        
    end
end
end