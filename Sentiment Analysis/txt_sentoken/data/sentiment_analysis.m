function [selected_words] = sentiment_analysis(file,threshold)
    %OPENING AND SCANNING TEXT FILES
    fid = fopen(file);
    s=textscan(fid,'%s');
    fclose(fid);
    
    %DETERMINING UNIQUE WORDS AND THEIR FREQUENCIES
    stringified=s{:};
    [unique_words,unique_words_i,unique_words_j]=unique(stringified);
    freq=hist(unique_words_j,(1:numel(unique_words_i))')';
    unique_vocab = [unique_words num2cell(freq)];
    
    %REMOVE MONOSYLLABLES AND SHORT WORDS e.g 'a','the','is'
    word_length = cellfun('length',unique_vocab);
    long_words = word_length(:,1) >= threshold;
    
    %WORDS LONGER THAN 'threshold' CHOSEN
    selected_words = unique_vocab(long_words,:);

end

