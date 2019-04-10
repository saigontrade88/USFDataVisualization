float mean(float[] data1){
    //calculate the mean
    float sum1 = 0;
    for (float f : data1)  sum1 += f;
    return  (sum1)/data1.length;
}

float SD(float[] data, float mu) {
    float sd=0;
    for (float f : data) {
      sd = sd + sq(f-mu);
    }
    //not calculating using n-1
    sd = sqrt(sd/(data.length));
    return sd;
}

float covariance(float[]data1, float[] data2){
    
    float rmean1 = mean(data1);
    float rmean2 = mean(data2);
    
    //float rsd1 = SD(rmean1);
    float sum = 0;
    
    if(data1.length != data2.length){
      return -1.0f;
    }
    for(int i = 0; i < data1.length; i++){
        sum = sum + (data1[i] - rmean1)*(data2[i] - rmean2);
        
    }
    
    return sum/(data1.length);
  }
 
  //determine PEARSON CORRELATION COEFFICIENT
 float correlation(float[] data1, float[] data2){
    
    return covariance(data1, data2)/(SD(data1, mean(data1)) * SD(data2, mean(data2)));
    
 }
float[] rankify(float[] data){
    
    
    int n = data.length;
    
    //Rank array
    float[] ranked = new float[n];
    
    for(int i = 0; i < n; i++){
        int r = 1, s = 1;
        //Count no of smaller elements in 0 to i-1
        for(int j = 0; j < i; j++){
            if(data[j] < data[i]) r++;
            if(data[j] == data[i]) s++;
        }
        // Count no of smaller elements 
        // in i+1 to N-1 
        for(int j = i + 1; j < n; j++){
            if(data[j] < data[i]) r++;
            if(data[j] == data[i]) s++;
        }
        // Use Fractional Rank formula 
        // fractional_rank = r + (n-1)/2 
        ranked[i] = r + (s-1) * 0.5;
        
    }
    return ranked;
}
//determine Spearman Rank Correlation
float SPC(float[] data1, float[] data2){
   
  if(data1.length != data2.length) return 0.0;
  
  float[] ranked1 = new float[data1.length];
  float[] ranked2 = new float[data2.length];
  
  ranked1 = rankify(data1);
  
  ranked2 = rankify(data2);
    
  return correlation(ranked1, ranked2);
 
 }
