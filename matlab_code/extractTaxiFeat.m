function [rawData buff ts_feat_time ts_feat_raw ts_feat_poly] = extractTaxiFeat(rawData)
%extractTaxiFeat
%   rawData: cell array obtained from Kaggle CSV data, this cell array was
%            obtained using swallow_csv function (swallow_csv allows low level parsing from C++ for speed)
%   see also: swallow_csv, mext
    [mts nts] = size(rawData);
    ts_feat_time = zeros(mts,1);   ts_feat_raw = zeros(mts,5);   ts_feat_poly = zeros(mts,20); 
    numGPS = 0;
    for i = 1:mts     %mts
       rawData{i} = regexprep(rawData{i},'[^0-9A-Z.-,]','');    %remove everything except [0-9.-,]
       buff{i} = regexp(rawData{i},',','split');  
       
       %feature1: callType [A B C] = [1 2 3]
            callType = double(char(buff{i}(1,2))) - 64;         %double(char(buff{i}(1,2))) 
       %feature2: taxiID = 
            taxiID = str2double(buff{i}(1,5))-20000000;
       %feature3: weekYear = week of the year : 1~53
       buffDate = str2double(buff{i}(1,6));                %in unix time
            formatOut = 'dd-mm-yyyy';
            D = datestr( unixtime_to_datenum( buffDate), formatOut);
            weekYear = weeknum(D); 
       %feature4: whourDay = quarter hour of the day : 1~96
            dhour = str2double( datestr( unixtime_to_datenum( buffDate), 'HH'));        %0 to 23
            dmin  = str2double( datestr( unixtime_to_datenum( buffDate), 'MM'));        %0 to 59
            whourDay = (dhour)*4 + floor(dmin/15) + 1;
       %feature5: dayNumber = day of the week : 1~7
            formatOut = 'mm/dd/yyyy';
            D = datestr( unixtime_to_datenum( buffDate), formatOut);
            dayNumber = weekday(D);
            
       ts_feat_raw(i,:) = [callType taxiID weekYear whourDay dayNumber];
       
       %get size of GPS trajectory : this also  correspond to total time: 1gps point for every 15 sec
            [mtraj ntraj] = size(buff{i}(1,9:end)');
            numGPS = (mtraj./2); 
            ts_feat_time(i,:) = numGPS * 15;
            if(numGPS < 1)      % no GPS entry, copy the previous
                ts_feat_raw(i,:) = ts_feat_raw(i-1,:);
                ts_feat_poly(i,:) = ts_feat_poly(i-1,:);
                ts_feat_time(i,:) = ts_feat_time(i-1,:);
            elseif(numGPS == 1)
                ts_feat_poly(i,:) = repmat( str2double([buff{i}(1,end-1) buff{i}(1,end)]), 1,10);
            elseif(numGPS > 1 && numGPS < 10)
                %repeat some values: duplicate the last value
                missingGPS = 10 - numGPS;
                for j = 0:numGPS-2
                    %1+j*2:2+j*2
                    ts_feat_poly(i,1+j*2:2+j*2) = str2double( [buff{i}(1,9+j*2) buff{i}(1,10+j*2)]);
                end
                %fill missing GPS points with last 2 seen GPS, divided 
                missHalf1 = ceil(missingGPS./2);
                for k = 1:missHalf1
                    ts_feat_poly(i,1+j*2+k*2:2+j*2+k*2) = str2double( [buff{i}(1,9+j*2) buff{i}(1,10+j*2)]);
                end
                missHalf2 = missingGPS - missHalf1;
                for l = 1:missHalf2 + 1
                    ts_feat_poly(i,1+j*2+k*2+l*2:2+j*2+k*2+l*2) = str2double( [buff{i}(1,end-1) buff{i}(1,end)]);
                end
            else
                %get the first 5 points and the last 5 points = 10 points = 20elements 
                ts_feat_poly(i,:) = str2double([buff{i}(1,9); buff{i}(1,10); buff{i}(1,11); buff{i}(1,12); buff{i}(1,13);...
                                             buff{i}(1,14); buff{i}(1,15); buff{i}(1,16); buff{i}(1,17); buff{i}(1,18);...
                                             buff{i}(1,end-9); buff{i}(1,end-8); buff{i}(1,end-7); buff{i}(1,end-6); buff{i}(1,end-5);...
                                             buff{i}(1,end-4); buff{i}(1,end-3); buff{i}(1,end-2); buff{i}(1,end-1); buff{i}(1,end)]' );
            end     
    end

end