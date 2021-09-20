function create_2phase_symmetric_filter(coef_num)

if (mod(coef_num,4) ~= 0)
    ME = MException('Function:InvalidArgument', ...
        'Coefficient number must be divisible by 4 without a remainder.');
    throw(ME)
end

%%% Create File Name
s = num2str(coef_num);
fileName = "mlhdlc_2_phase_symmetric_"+s+"_tap_filter";

%%% Create, Define and Initialize Persistents
ud_array =string;
definePersistents = "persistent";
ifBegin = "if isempty(ud1)";
ifInside = string;
for i=1:(coef_num)
    ud_array(1,i) = "ud"+num2str(i);
    definePersistents = definePersistents+" "+ud_array(i);
    ifInside = ifInside+ud_array(i)+"=0; ";
    if(mod(i,6)==0)
        ifInside = ifInside + "\n\t";
    end
end
definePersistents = definePersistents+" Z;";
ifInside = ifInside+"Z=0; ";
ifEnd = "end";

%%% Create and Define Filter Coeff and Inputs
h_array = string;
for i=1:(coef_num/2)
    h_array(1,i) = "h"+num2str(i);
end

h_array1=h_array(1:2:end);
h_array2=h_array(2:2:end);
h_sub1=string(coef_num/4);
h_sub2=string(coef_num/4);
h_sub3=string(coef_num/4);
defineSubfilter1 = string;
defineSubfilter2 = string;
defineSubfilter3 = string;
ud_array1=ud_array(1:2:end);
ud_array2=ud_array(2:2:end);
x_sub1=string(coef_num/4);
x_sub2=string(coef_num/4);
x_sub3=string(coef_num/4);
defineInput1 = string;
defineInput2 = string;
defineInput3 = string;
shift1 = string;
shift2 = string;

for i=1:(coef_num/4)
    x_sub1(1,i) = "x1_"+num2str(i);
    x_sub2(1,i) = "x2_"+num2str(i);
    x_sub3(1,i) = "x3_"+num2str(i);
    defineInput1 = defineInput1 + x_sub1(i)+"="+ud_array1(i)+"-"+ud_array2(i)+";\n";
    defineInput2 = defineInput2 + x_sub2(i)+"="+ud_array1(i)+"+"+ud_array2(i)+";\n";
    defineInput3 = defineInput3 + x_sub3(i)+"="+ud_array2(i)+";\n";
    h_sub3(1,i) = "h3_"+num2str(i);
    h_sub1(1,i) = "h1_"+num2str(i);
    h_sub2(1,i) = "h2_"+num2str(i);
    defineSubfilter1 = defineSubfilter1 + h_sub1(i)+"="+h_array1(i)+"-"+h_array2(i)+";\n";
    defineSubfilter2 = defineSubfilter2 + h_sub2(i)+"="+h_array1(i)+"+"+h_array2(i)+";\n";
    defineSubfilter3 = defineSubfilter3 + h_sub3(i)+"="+h_array2(i)+";\n";
    shift1 = shift1 + h_sub1(i)+"="+h_sub1(i)+"/2;\n";
    shift2 = shift2 + h_sub2(i)+"="+h_sub2(i)+"/2;\n";
end

for i=(coef_num/4)+1:(coef_num/2)
    x_sub1(1,i) = "x1_"+num2str(i);
    x_sub2(1,i) = "x2_"+num2str(i);
    x_sub3(1,i) = "x3_"+num2str(i);
    defineInput1 = defineInput1 + x_sub1(i)+"="+ud_array1(i)+"-"+ud_array2(i)+";\n";
    defineInput2 = defineInput2 + x_sub2(i)+"="+ud_array1(i)+"+"+ud_array2(i)+";\n";
    defineInput3 = defineInput3 + x_sub3(i)+"="+ud_array2(i)+";\n";
    h_sub3(1,i) = "h3_"+num2str(i);
    defineSubfilter3 = defineSubfilter3 + h_sub3(i)+"="+h_array1((coef_num/2)-i+1)+";\n";
end

%%% Define Function
filter_coef = string;
for i=1:(coef_num/2)
    filter_coef = filter_coef+","+h_array(i);
end
functionName = "function [y_out1,y_out2] ="+fileName+"(x_in1,x_in2"+filter_coef+")";

%%% Create Adder Chain Variables for symmetric filters
adder_chain_length = coef_num/4;
sum_old = coef_num/4;
sum_old2 = sum_old;

while sum_old > 2 || (sum_old ==2 && mod(sum_old2,2) == 0)
    if mod(sum_old,2) == 0
        sum_new = sum_old / 2;
    else
        sum_new = (sum_old+1)/2;
    end
    adder_chain_length = adder_chain_length + sum_new;
    sum_old = sum_new;
    sum_old2 = sum_old;
end

adder_chain_length_non_symm = 0;
sum_old_non_symm = coef_num/2;
sum_old2_non_symm = sum_old_non_symm;

while sum_old_non_symm > 2 || (sum_old_non_symm ==2 && mod(sum_old2_non_symm,2) == 0)
    if mod(sum_old_non_symm,2) == 0
        sum_new_non_symm = sum_old_non_symm / 2;
    else
        sum_new_non_symm = (sum_old_non_symm+1)/2;
    end
    adder_chain_length_non_symm = adder_chain_length_non_symm + sum_new_non_symm;
    sum_old_non_symm = sum_new_non_symm;
    sum_old2_non_symm = sum_old_non_symm;
end

a_array1 = string;
a_array2 = string;
for i=1:(adder_chain_length)
    a_array1(1,i) = "a1_"+num2str(i);
    a_array2(1,i) = "a2_"+num2str(i);
end

a_array3 = string;
for i=1:(adder_chain_length_non_symm)
    a_array3(1,i) = "a3_"+num2str(i);
end

%%% Create First Adders Chain of Symmetric Filters (h1+h2,h1-h2)

AdderChain1 = string;
AdderChain2 = string;
AdderChain3 = string;
for i=1:(coef_num/4)
    AdderChain1(i) = a_array1(i)+"="+x_sub1(i)+"-"+x_sub1(end+1-i)+";";
    AdderChain2(i) = a_array2(i)+"="+x_sub2(i)+"+"+x_sub2(end+1-i)+";";
end

%%% Multiplier Chain
m_array1 = string();
m_array2 = string();
m_array3 = string();
multChain1 = string(m_array1);
multChain2 = string(m_array2);
multChain3 = string(m_array3);
for i=1:(coef_num/4)
    m_array1(1,i) = "m1_"+num2str(i);
    m_array2(1,i) = "m2_"+num2str(i);
    multChain1(i) = m_array1(i)+"="+h_sub1(i)+"*"+a_array1(i)+";";
    multChain2(i) = m_array2(i)+"="+h_sub2(i)+"*"+a_array2(i)+";";
end

for i=1:coef_num/2
    m_array3(1,i) = "m3_"+num2str(i);
    multChain3(i) = m_array3(i)+"="+h_sub3(i)+"*"+x_sub3(i)+";";
end

%%% Create Adder Chain Variables for symmetric subfilters

len = length(m_array1);
total_len = len;
first = 1 ;

while len > 1
    if(mod(len,2)==0)
        j=total_len-len+1;
        k=1;
        if (first == 1)
            for i=total_len+1:(total_len + len/2)
                AdderChain1(i) = a_array1(i)+"="+m_array1(j)+"+"+m_array1(end+1-k)+";";
                AdderChain2(i) = a_array2(i)+"="+m_array2(j)+"+"+m_array2(end+1-k)+";";
                j=j+1;
                k=k+1;
            end
            first = 0 ;
        else
            for i=total_len+1:(total_len + len/2)
                AdderChain1(i) = a_array1(i)+"="+a_array1(j)+"+"+a_array1(total_len+1-k)+";";
                AdderChain2(i) = a_array2(i)+"="+a_array2(j)+"+"+a_array2(total_len+1-k)+";";
                j=j+1;
                k=k+1;
            end
        end
        len=len/2;
    else
        j=total_len-len+1;
        if (first == 1)
            for i=total_len+1:(total_len + (len-1)/2)
                AdderChain1(i) = a_array1(i)+"="+m_array1(j)+"+"+m_array1(j+1)+";";
                AdderChain2(i) = a_array2(i)+"="+m_array2(j)+"+"+m_array2(j+1)+";";
                j=j+2;
                % add
                if (i == (total_len + (len-1)/2))
                    AdderChain1(i+1) = a_array1(i+1)+"="+m_array1(j)+";";
                    AdderChain2(i+1) = a_array2(i+1)+"="+m_array2(j)+";";
                end
            end
            first = 0 ;
        else
            for i=total_len+1:(total_len + (len-1)/2)
                AdderChain1(i) = a_array1(i)+"="+a_array1(j)+"+"+a_array1(j+1)+";";
                AdderChain2(i) = a_array2(i)+"="+a_array2(j)+"+"+a_array2(j+1)+";";
                j=j+2;
                % add
                if (i == (total_len + (len-1)/2))
                    AdderChain1(i+1) = a_array1(i+1)+"="+a_array1(j)+";";
                    AdderChain2(i+1) = a_array2(i+1)+"="+a_array2(j)+";";
                end
                
            end
        end
        len=(len+1)/2;
    end
    total_len = total_len + len;
end

%%% Create Adder Chain Variables for unsymmetric subfilters
len3 = length(m_array3);
total_len3 = 0;
first = 1 ;

while len3 > 1
    if(mod(len3,2)==0)
        if(first==1)
            for i=1:len3/2
                AdderChain3(i) = a_array3(i)+"="+m_array3(i)+"+"+m_array3(end-i+1)+";";
            end
            first = 0;
        else
            j=1;
            for i=total_len3+1:total_len3+(len3/2)
                AdderChain3(i) = a_array3(i)+"="+a_array3(i-len3)+"+"+a_array3(i-j)+";";
                j=j+2;
            end
        end
        len3 = len3/2;
    else
        if(first==1)
            j=1;
            for i=1:(len3-1)/2
                AdderChain3(i) = a_array3(i)+"="+m_array3(j)+"+"+m_array3(j+1)+";";
                j=j+2;
                %add
                if(i==(total_len3)+((len3-1)/2))
                    AdderChain3(i+1) = a_array3(i+1)+"="+m_array3(j)+";";
                end
            end
            first = 0;
        else
            j=total_len3-len3+1;
            for i=total_len3+1:total_len3+((len3-1)/2)
                AdderChain3(i) = a_array3(i)+"="+a_array3(j)+"+"+a_array3(j+1)+";";
                j=j+2;
                if (i == (total_len3 + (len3-1)/2))
                    AdderChain3(i+1) = a_array3(i+1)+"="+a_array3(j)+";";
                end
            end
        end
        len3 = (len3+1)/2;
    end
    total_len3 = total_len3 + len3;
end

%%% Create and Calculate outputs
defineOutput1 = "y1 = "+a_array1(end)+";\n";
defineOutput2 = "y2 = "+a_array2(end)+";\n";
defineOutput3 = "y3 = "+a_array3(end)+";\n";
output = "temp1 = Z - y3;\ntemp2 = y1 + y2;\ny_out1 = temp1+temp2;\ny_out2 = y2 - y1;";

%%% Update Delays
updateDelays = string;
for i=1:(coef_num-2)
    updateDelays(i) = ud_array(coef_num+1-i)+"="+ud_array(coef_num-i-1)+";";
end
updateDelays(coef_num-1) = ud_array(1)+"="+"x_in1;";
updateDelays(coef_num) = ud_array(2)+"="+"x_in2;";
updateDelays(coef_num+1) = "Z = y3;";

%%% Write to file
fileID = fopen(fileName+".m",'w');
fprintf(fileID,functionName+"\n\n");
fprintf(fileID,definePersistents+"\n\n");
fprintf(fileID,ifBegin+"\n");
fprintf(fileID,"\t"+ifInside+"\n");
fprintf(fileID,ifEnd+"\n\n");

%%% Subfilter1
fprintf(fileID,defineInput1+"\n\n");
fprintf(fileID,defineSubfilter1+"\n\n");
fprintf(fileID,shift1+"\n\n");
for i=1:coef_num/4
    fprintf(fileID,AdderChain1(i)+"\n");
end

fprintf(fileID,"\n");

for i=1:length(multChain1)
    fprintf(fileID,multChain1(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=(coef_num/4)+1:length(AdderChain1)
    fprintf(fileID,AdderChain1(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput1);
fprintf(fileID,"\n\n");

%%% Subfilter2
fprintf(fileID,defineInput2+"\n\n");
fprintf(fileID,defineSubfilter2+"\n\n");
fprintf(fileID,shift2+"\n\n");
for i=1:coef_num/4
    fprintf(fileID,AdderChain2(i)+"\n");
end

fprintf(fileID,"\n");

for i=1:length(multChain2)
    fprintf(fileID,multChain2(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=(coef_num/4)+1:length(AdderChain2)
    fprintf(fileID,AdderChain2(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput2);
fprintf(fileID,"\n\n");

%%% Subfilter3
fprintf(fileID,defineInput3+"\n\n");
fprintf(fileID,defineSubfilter3+"\n\n");
fprintf(fileID,"\n");

for i=1:length(multChain3)
    fprintf(fileID,multChain3(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=1:length(AdderChain3)
    fprintf(fileID,AdderChain3(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput3);
fprintf(fileID,"\n\n");
fprintf(fileID,output);
fprintf(fileID,"\n\n");

for i=1:length(updateDelays)
    fprintf(fileID,updateDelays(i)+"\n");
end

fprintf(fileID,ifEnd);

end