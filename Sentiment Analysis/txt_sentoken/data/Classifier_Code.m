clc;
close all;
clear all;
tic
train_files = 1:980;
test_files = 1:20;
threshold = 4;

%TRAINING FOR POSITIVE CLASS INSTANCES
pos_bag_of_words = cell(length(train_files),1);
pos_bag_of_words(:) = {''};
for i=train_files 
    
    %OPENING AND SCANNING TRAINING TEXT FILE WITH 'POS' CLASS
    file = sprintf('cv_train_pos (%d).txt',i);
    selected_words = sentiment_analysis(file,threshold);
    
    %LONG WORDS CHOSEN
    [~,I] = max(cell2mat(selected_words(:,2)));
    
    %BAG OF WORDS FOR POSITIVE CLASS
    pos_bag_of_words(i,1) = selected_words(I);
    
end

%TRAINING FOR NEGATIVE CLASS INSTANCES
neg_bag_of_words = cell(length(train_files),1);
neg_bag_of_words(:) = {''};
for j=train_files
    %OPENING AND SCANNING TRAINING TEXT FILES WITH 'POS' CLASS
    file = sprintf('cv_train_neg (%d).txt',j);
    selected_words = sentiment_analysis(file,threshold);
    
    %LONG WORDS CHOSEN
    [~,I] = max(cell2mat(selected_words(:,2)));
    
    %BAG OF WORDS FOR POSITIVE CLASS
    neg_bag_of_words(j,1) = selected_words(I);  
    
end

%REMOVE DUPLICATE WORDS FROM THE BAG OF WORDS
pos_bag_of_words = unique(pos_bag_of_words);
neg_bag_of_words = unique(neg_bag_of_words);

predicted_polarity = cell(length(test_files),1);
predicted_polarity (:) = {''};

true_positive=0;true_negative=0;

%TESTING POSITIVE TEST FILES AND INCREMENTING TRUE_POSITIVE
for k=test_files
    %OPENING AND SCANNING TEST FILE WITH 'POS' CLASS
    file = sprintf('cv_test_pos (%d).txt',k);
    
    selected_words = sentiment_analysis(file,threshold);
    
    %LONG WORDS CHOSEN
    [~,I] = max(cell2mat(selected_words(:,2)));
    
    %COMPARING COMMON WORDS IN TRAIN AND TEST BAGS
    common_words = intersect(pos_bag_of_words,selected_words(I));
    common_words = length(common_words);
    if(common_words>0)
        predicted_polarity(k,1) = {'pos'};
        true_positive = true_positive+1;
    end      
end

%TESTING NEGATIVE TEST FILES AND INCREMENTING TRUE_NEGATIVE
for k=test_files
    %OPENING AND SCANNING TEST FILE WITH 'POS' CLASS
    file = sprintf('cv_test_neg (%d).txt',k);
    
    selected_words = sentiment_analysis(file,threshold);
    
    %LONG WORDS CHOSEN
    [~,I] = max(cell2mat(selected_words(:,2)));
    
    %COMPARING COMMON WORDS IN TRAIN AND TEST BAGS
    common_words = intersect(neg_bag_of_words,selected_words(I));
    common_words = length(common_words);
    if(common_words>0)
        predicted_polarity(k,1) = {'neg'};
        true_negative = true_negative+1;
    end      
end
accuracy = 100*(true_positive+true_negative)/40

toc
