function create_3_phase_ffa_sym_filter(coef_num)

if (mod(coef_num,6) ~= 0)
    ME = MException('Function:InvalidArgument', ...
        'Coefficient number must be divisible by 6 without a remainder.');
    throw(ME)
end

%%% Create File Name
s = num2str(coef_num);
fileName = "mlhdlc_3_phase_ffa_sym_"+s+"tap_filter";

%%% Define Persistents
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
ifInside = ifInside+"Z1=0; Z2=0;";
ifEnd = "end";
definePersistents = definePersistents+" Z1 Z2 ;";

%%% Create and Define Filter Coeff and Inputs
h_array = string;
for i=1:(coef_num/2)
    h_array(1,i) = "h"+num2str(i);
end

h_array1=h_array(1:3:end);
h_array2=h_array(2:3:end);
h_array3=h_array(3:3:end);
h_sub1=string(coef_num/3);
h_sub2=string(coef_num/3);
h_sub3=string(coef_num/6);
h_sub4=string(coef_num/6);
h_sub5=string(coef_num/6);
h_sub6=string(coef_num/6);
defineSubfilter1 = string;
defineSubfilter2 = string;
defineSubfilter3 = string;
defineSubfilter4 = string;
defineSubfilter5 = string;
defineSubfilter6 = string;
ud_array1=ud_array(1:3:end);
ud_array2=ud_array(2:3:end);
ud_array3=ud_array(3:3:end);
x_sub1=string(coef_num/6);
x_sub2=string(coef_num/6);
x_sub3=string(coef_num/6);
x_sub4=string(coef_num/6);
x_sub5=string(coef_num/6);
x_sub6=string(coef_num/6);
defineInput1 = string;
defineInput2 = string;
defineInput3 = string;
defineInput4 = string;
defineInput5 = string;
defineInput6 = string;


for i=1:(coef_num/6)
    x_sub1(1,i) = "x1_"+num2str(i);
    x_sub2(1,i) = "x2_"+num2str(i);
    x_sub3(1,i) = "x3_"+num2str(i);
    x_sub4(1,i) = "x4_"+num2str(i);
    x_sub5(1,i) = "x5_"+num2str(i);
    x_sub6(1,i) = "x6_"+num2str(i);
    defineInput1 = defineInput1 + x_sub1(i)+"="+ud_array1(i)+";\n";
    defineInput2 = defineInput2 + x_sub2(i)+"="+ud_array2(i)+";\n";
    defineInput3 = defineInput3 + x_sub3(i)+"="+ud_array3(i)+";\n";
    defineInput4 = defineInput4 + x_sub4(i)+"="+ud_array1(i)+"+"+ud_array2(i)+";\n";
    defineInput5 = defineInput5 + x_sub5(i)+"="+ud_array2(i)+"+"+ud_array3(i)+";\n";
    defineInput6 = defineInput6 + x_sub6(i)+"="+ud_array1(i)+"+"+ud_array2(i)+"+"+ud_array3(i)+";\n";
    h_sub1(1,i) = "h1_"+num2str(i);
    h_sub2(1,i) = "h2_"+num2str(i);
    h_sub3(1,i) = "h3_"+num2str(i);
    h_sub4(1,i) = "h4_"+num2str(i);
    h_sub5(1,i) = "h5_"+num2str(i);
    h_sub6(1,i) = "h6_"+num2str(i);
    defineSubfilter1 = defineSubfilter1 + h_sub1(i)+"="+h_array1(i)+";\n";
    defineSubfilter2 = defineSubfilter2 + h_sub2(i)+"="+h_array2(i)+";\n";
    defineSubfilter3 = defineSubfilter3 + h_sub3(i)+"="+h_array3(i)+";\n";
    defineSubfilter4 = defineSubfilter4 + h_sub4(i)+"="+h_array1(i)+"+"+h_array2(i)+";\n";
    defineSubfilter5 = defineSubfilter5 + h_sub5(i)+"="+h_array2(i)+"+"+h_array3(i)+";\n";
    defineSubfilter6 = defineSubfilter6 + h_sub6(i)+"="+h_array1(i)+"+"+h_array2(i)+"+"+h_array3(i)+";\n";

end

for i=(coef_num/6)+1:(coef_num/3)
    x_sub1(1,i) = "x1_"+num2str(i);
    x_sub2(1,i) = "x2_"+num2str(i);
    x_sub3(1,i) = "x3_"+num2str(i);
    x_sub4(1,i) = "x4_"+num2str(i);
    x_sub5(1,i) = "x5_"+num2str(i);
    x_sub6(1,i) = "x6_"+num2str(i);
    defineInput1 = defineInput1 + x_sub1(i)+"="+ud_array1(i)+";\n";
    defineInput2 = defineInput2 + x_sub2(i)+"="+ud_array2(i)+";\n";
    defineInput3 = defineInput3 + x_sub3(i)+"="+ud_array3(i)+";\n";
    defineInput4 = defineInput4 + x_sub4(i)+"="+ud_array1(i)+"+"+ud_array2(i)+";\n";
    defineInput5 = defineInput5 + x_sub5(i)+"="+ud_array2(i)+"+"+ud_array3(i)+";\n";
    defineInput6 = defineInput6 + x_sub6(i)+"="+ud_array1(i)+"+"+ud_array2(i)+"+"+ud_array3(i)+";\n";
    h_sub1(1,i) = "h1_"+num2str(i);
    h_sub2(1,i) = "h2_"+num2str(i);
    h_sub3(1,i) = "h3_"+num2str(i);
    h_sub4(1,i) = "h4_"+num2str(i);
    h_sub5(1,i) = "h5_"+num2str(i);
    h_sub6(1,i) = "h6_"+num2str(i);
    defineSubfilter1 = defineSubfilter1 + h_sub1(i)+"="+h_array3((coef_num/3)-i+1)+";\n";
    defineSubfilter2 = defineSubfilter2 + h_sub2(i)+"="+h_array2((coef_num/3)-i+1)+";\n";
    defineSubfilter3 = defineSubfilter3 + h_sub3(i)+"="+h_array1((coef_num/3)-i+1)+";\n";
    defineSubfilter4 = defineSubfilter4 + h_sub4(i)+"="+h_array3((coef_num/3)-i+1)+"+"+h_array2((coef_num/3)-i+1)+";\n";
    defineSubfilter5 = defineSubfilter5 + h_sub5(i)+"="+h_array2((coef_num/3)-i+1)+"+"+h_array1((coef_num/3)-i+1)+";\n";
    defineSubfilter6 = defineSubfilter6 + h_sub6(i)+"="+h_array1((coef_num/3)-i+1)+"+"+h_array2((coef_num/3)-i+1)+"+"+h_array3((coef_num/3)-i+1)+";\n";

end

%%% Define Function
filter_coef = string;
for i=1:(coef_num/2)
    filter_coef = filter_coef+","+h_array(i);
end

functionName = "function [y_out1,y_out2,y_out3] ="+fileName+"(x_in1,x_in2,x_in3"+filter_coef+")";

%%% Create Adder Chain Variables for symmetric subfilters
adder_chain_length = coef_num/6;
sum_old = coef_num/6;
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

%%% Create Adder Chain Variables for unsymmetric subfilters
adder_chain_length_non_symm = 0;
sum_old_non_symm = coef_num/3;
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
a_array3 = string;
a_array4 = string;
a_array5 = string;
a_array6 = string;



for i=1:(adder_chain_length_non_symm)
    a_array1(1,i) = "a1_"+num2str(i);
    a_array2(1,i) = "a2_"+num2str(i);
    a_array3(1,i) = "a3_"+num2str(i);
    a_array4(1,i) = "a4_"+num2str(i);
    a_array5(1,i) = "a5_"+num2str(i);
    a_array6(1,i) = "a6_"+num2str(i);
end

%%% Create First Adders Chain of Symmetric Filters 

AdderChain1 = string;
AdderChain2 = string;
AdderChain3 = string;
AdderChain4 = string;
AdderChain5 = string;
AdderChain6 = string;



%%% Multiplier Chain
m_array1 = string();
m_array2 = string();
m_array3 = string();
m_array4 = string();
m_array5 = string();
m_array6 = string();
multChain1 = string(m_array1);
multChain2 = string(m_array2);
multChain3 = string(m_array3);
multChain4 = string(m_array4);
multChain5 = string(m_array5);
multChain6 = string(m_array6);


for i=1:coef_num/3
    m_array1(1,i) = "m1_"+num2str(i);
    m_array2(1,i) = "m2_"+num2str(i);
    m_array3(1,i) = "m3_"+num2str(i);
    m_array4(1,i) = "m4_"+num2str(i);
    m_array5(1,i) = "m5_"+num2str(i);
    m_array6(1,i) = "m6_"+num2str(i);
    
    multChain1(i) = m_array1(i)+"="+h_sub1(i)+"*"+x_sub1(i)+";";
    multChain2(i) = m_array2(i)+"="+h_sub2(i)+"*"+x_sub2(i)+";";
    multChain3(i) = m_array3(i)+"="+h_sub3(i)+"*"+x_sub3(i)+";";
    multChain4(i) = m_array4(i)+"="+h_sub4(i)+"*"+x_sub4(i)+";";
    multChain5(i) = m_array5(i)+"="+h_sub5(i)+"*"+x_sub5(i)+";";
    multChain6(i) = m_array6(i)+"="+h_sub6(i)+"*"+x_sub6(i)+";";
end



%%% Adder Chain for unsymmetric subfilters
len3 = length(m_array1);
total_len3 = 0;
first = 1 ;

while len3 > 1
    if(mod(len3,2)==0)
        if(first==1)
            for i=1:len3/2
                AdderChain1(i) = a_array1(i)+"="+m_array1(i)+"+"+m_array1(end-i+1)+";";
                AdderChain2(i) = a_array2(i)+"="+m_array2(i)+"+"+m_array2(end-i+1)+";";
                AdderChain3(i) = a_array3(i)+"="+m_array3(i)+"+"+m_array3(end-i+1)+";";
                AdderChain4(i) = a_array4(i)+"="+m_array4(i)+"+"+m_array4(end-i+1)+";";
                AdderChain5(i) = a_array5(i)+"="+m_array5(i)+"+"+m_array5(end-i+1)+";";
                AdderChain6(i) = a_array6(i)+"="+m_array6(i)+"+"+m_array6(end-i+1)+";";
            end
            first = 0;
        else
            j=1;
            for i=total_len3+1:total_len3+(len3/2)
                AdderChain1(i) = a_array1(i)+"="+a_array1(i-len3)+"+"+a_array1(i-j)+";";
                AdderChain2(i) = a_array2(i)+"="+a_array2(i-len3)+"+"+a_array2(i-j)+";";
                AdderChain3(i) = a_array3(i)+"="+a_array3(i-len3)+"+"+a_array3(i-j)+";";
                AdderChain4(i) = a_array4(i)+"="+a_array4(i-len3)+"+"+a_array4(i-j)+";";
                AdderChain5(i) = a_array5(i)+"="+a_array5(i-len3)+"+"+a_array5(i-j)+";";
                AdderChain6(i) = a_array6(i)+"="+a_array6(i-len3)+"+"+a_array6(i-j)+";";                
                j=j+2;
            end
        end
        len3 = len3/2;
    else
        if(first==1)
            j=1;
            for i=1:(len3-1)/2
                AdderChain1(i) = a_array1(i)+"="+m_array1(j)+"+"+m_array1(j+1)+";";
                AdderChain2(i) = a_array2(i)+"="+m_array2(j)+"+"+m_array2(j+1)+";";
                AdderChain3(i) = a_array3(i)+"="+m_array3(j)+"+"+m_array3(j+1)+";";
                AdderChain4(i) = a_array4(i)+"="+m_array4(j)+"+"+m_array4(j+1)+";";
                AdderChain5(i) = a_array5(i)+"="+m_array5(j)+"+"+m_array5(j+1)+";";
                AdderChain6(i) = a_array6(i)+"="+m_array6(j)+"+"+m_array6(j+1)+";";                
                j=j+2;
                %add
                if(i==(total_len3)+((len3-1)/2))
                    AdderChain1(i+1) = a_array1(i+1)+"="+m_array1(j)+";";
                    AdderChain2(i+1) = a_array2(i+1)+"="+m_array2(j)+";";
                    AdderChain3(i+1) = a_array3(i+1)+"="+m_array3(j)+";";
                    AdderChain4(i+1) = a_array4(i+1)+"="+m_array4(j)+";";
                    AdderChain5(i+1) = a_array5(i+1)+"="+m_array5(j)+";";
                    AdderChain6(i+1) = a_array6(i+1)+"="+m_array6(j)+";";                    
                end
            end
            first = 0;
        else
            j=total_len3-len3+1;
            for i=total_len3+1:total_len3+((len3-1)/2)
                AdderChain1(i) = a_array1(i)+"="+a_array1(j)+"+"+a_array1(j+1)+";";
                AdderChain2(i) = a_array2(i)+"="+a_array2(j)+"+"+a_array2(j+1)+";";
                AdderChain3(i) = a_array3(i)+"="+a_array3(j)+"+"+a_array3(j+1)+";";
                AdderChain4(i) = a_array4(i)+"="+a_array4(j)+"+"+a_array4(j+1)+";";
                AdderChain5(i) = a_array5(i)+"="+a_array5(j)+"+"+a_array5(j+1)+";";
                AdderChain6(i) = a_array6(i)+"="+a_array6(j)+"+"+a_array6(j+1)+";";                
                j=j+2;
                if (i == (total_len3 + (len3-1)/2))
                    AdderChain1(i+1) = a_array1(i+1)+"="+a_array1(j)+";";
                    AdderChain2(i+1) = a_array2(i+1)+"="+a_array2(j)+";";
                    AdderChain3(i+1) = a_array3(i+1)+"="+a_array3(j)+";";
                    AdderChain4(i+1) = a_array4(i+1)+"="+a_array4(j)+";";
                    AdderChain5(i+1) = a_array5(i+1)+"="+a_array5(j)+";";
                    AdderChain6(i+1) = a_array6(i+1)+"="+a_array6(j)+";";                   
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
defineOutput4 = "y4 = "+a_array4(end)+";\n";
defineOutput5 = "y5 = "+a_array5(end)+";\n";
defineOutput6 = "y6 = "+a_array6(end)+";\n";
output1 = "temp0 = y1-Z1;\ntemp1 = y5-y2;\ny_out1 =temp0 + Z2;\n";
output2 = "temp2 = y4-y2;\ny_out2 = temp2 - temp0;\n ";
output3 = "temp3 = y6 - temp2;\ny_out3 = temp3 - temp1;\n";

%%% Update Delays

updateDelays = string;

for i=1:(coef_num-3)
    updateDelays(i) = ud_array(coef_num+1-i)+"="+ud_array(coef_num-i-2)+";";
end
updateDelays(coef_num-2) = ud_array(1)+"="+"x_in1;";
updateDelays(coef_num-1) = ud_array(2)+"="+"x_in2;";
updateDelays(coef_num) = ud_array(3)+"="+"x_in3;";
updateDelays(coef_num+1) = "Z1 = y3; \nZ2 = temp1;";

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
fprintf(fileID,"\n");

for i=1:length(multChain1)
    fprintf(fileID,multChain1(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=1:length(AdderChain1)
    fprintf(fileID,AdderChain1(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput1);
fprintf(fileID,"\n\n");

%%% Subfilter2
fprintf(fileID,defineInput2+"\n\n");
fprintf(fileID,defineSubfilter2+"\n\n");
fprintf(fileID,"\n");

for i=1:length(multChain2)
    fprintf(fileID,multChain2(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=1:length(AdderChain2)
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

%%% Subfilter4
fprintf(fileID,defineInput4+"\n\n");
fprintf(fileID,defineSubfilter4+"\n\n");
fprintf(fileID,"\n");

for i=1:length(multChain4)
    fprintf(fileID,multChain4(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=1:length(AdderChain4)
    fprintf(fileID,AdderChain4(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput4);
fprintf(fileID,"\n\n");

%%% Subfilter5
fprintf(fileID,defineInput5+"\n\n");
fprintf(fileID,defineSubfilter5+"\n\n");
fprintf(fileID,"\n");

for i=1:length(multChain5)
    fprintf(fileID,multChain5(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=1:length(AdderChain5)
    fprintf(fileID,AdderChain5(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput5);
fprintf(fileID,"\n\n");


%%% Subfilter6
fprintf(fileID,defineInput6+"\n\n");
fprintf(fileID,defineSubfilter6+"\n\n");
fprintf(fileID,"\n");

for i=1:length(multChain6)
    fprintf(fileID,multChain6(i)+"\n");
end

fprintf(fileID,"\n\n");

for i=1:length(AdderChain6)
    fprintf(fileID,AdderChain6(i)+"\n");
end

fprintf(fileID,"\n\n");
fprintf(fileID,defineOutput6);
fprintf(fileID,"\n\n");

fprintf(fileID,output1);
fprintf(fileID,"\n");
fprintf(fileID,output2);
fprintf(fileID,"\n");
fprintf(fileID,output3);
fprintf(fileID,"\n\n");

for i=1:length(updateDelays)
    fprintf(fileID,updateDelays(i)+"\n");
end

fprintf(fileID,ifEnd);

end