clc;
clear all;
close all;
tic
[~,train_data,~] = xlsread('Training_Data.xlsx',1);
[~,test_data,~] = xlsread('Testing_Data.xlsx',1);

[train_instances,n] = size(train_data);
[test_instances,o] = size(test_data);

%COUNT OF UNIQUE VOCABULARY IN THE ENTIRE TRAINING DATA. REMOVE ANY EMPTY WHITE
%SPACE PRESENT IN THE VOCABULARY
V = unique(train_data(:,2:end));
[blanks] = find(strcmp('',V));V(blanks,:) = [];
[V,~] = size(V); %NUMBER OF UNIQUE WORDS PRESENT

%DETERMINING UNIQUE CLASSES
x = train_data(:,1);
[x1,x2,x2]=unique(x);
x2=accumarray(x2,1);
classes = [x1,num2cell(x2)];%UNIQUE CLASSES
[classes_number,~] = size(classes);%NUMBER OF UNIQUE CLASSES

%FOR STORING THE PREDICTED CLASSES
final_table = cell(test_instances,1);
final_table(:) = {''};

%FOR STORING POSTERIOR PROBABILITIES
post_prob = zeros(1,classes_number);
 
for p=1:test_instances
    %WORDS IN AN INSTANCE E.G {'How','are','you'}
    words_in_a_row = sum(~strcmp(test_data(p,2:end),''));
    conditional_probabilities = zeros(classes_number,words_in_a_row);    
    for q=1:classes_number %CONDITIONAL PROBABILITIES FOR EACH WORD:CLASS        
        
        %RUNNING FOR e.g. CLASS 'C' 
        class_word_count = 0;
        
        %TOTAL NUMBER OF TIMES CLASS 'C' OCCURS
        b = cell2mat(classes(q,2));
        
        %ROWS IN WHICH CLASS 'C' OCCURS
        [rows] = find(strcmp(classes(q),train_data));
        [g,~] = size(rows);
        
        %TOTAL WORDS IN ALL THE ROWS IN WHICH THE CLASS 'C' OCCURS
        for i=1:g
          class_word_count = sum(~strcmp(train_data(rows(i),2:end),''))+class_word_count;
        end
        
        for r=1:words_in_a_row
            %RUNNING FOR e.g 'How'
            count = 0;
            
            test_word = test_data(p,(r+1));           
            if (~isempty(rows))
                for i=1:g
                    for j=1:n
                        if(strcmp(test_word,train_data(rows(i),j)))
                            count = count + 1;
                        end
                    end
                end
            else              
                count=0;
            end
            conditional_probabilities(q,r) = (count+1)/(class_word_count+V);
        end
        post_prob(1,q) = (b/train_instances)*prod(conditional_probabilities(q,:));
    end
 [~,I] = max(post_prob);
 iteration = p
 final_table(p,1) =  classes(I,1);
end
[rows] = find(strcmp(final_table(:,1),test_data(:,1)));
[tp,~] = size(rows);
accuracy = 100*tp/test_instances
toc
