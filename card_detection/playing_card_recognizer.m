    close all;
    clc;
    
    im = imread('images/10clubs.jpg');
    im = imresize(im,1/2,'bilinear');
    
    [rows, columns, ~] = size(im);
    if rows < 3000/2 && columns < 3000/2
        im = imresize(im,3,'bilinear');
    end
    
    if size(im,1) < size(im,2)
        im = imrotate(im,90);
    end

    newImg = im;

    spades = imread('Templates/Suits/newMaca2.jpg');
    hearts = imread('Templates/Suits/newKupa2.jpg');
    diamonds = imread('Templates/Suits/newKaro2.jpg');
    clubs = imread('Templates/Suits/newSinek2.jpg');

    rank_A = imread('Templates/Ranks/newA.jpg');
    rank_2 = imread('Templates/Ranks/new2.jpg');
    rank_3 = imread('Templates/Ranks/new3.jpg');
    rank_4 = imread('Templates/Ranks/new4.jpg');
    rank_5 = imread('Templates/Ranks/new5.jpg');
    rank_6 = imread('Templates/Ranks/new6.jpg');
    rank_7 = imread('Templates/Ranks/new7.jpg');
    rank_8 = imread('Templates/Ranks/new8.jpg');
    rank_9 = imread('Templates/Ranks/new9.jpg');
    rank_10 = imread('Templates/Ranks/new10 - Copy.jpg');
    rank_J = imread('Templates/Ranks/newJ.jpg');
    rank_Q = imread('Templates/Ranks/newQ - Copy.jpg');
    rank_K = imread('Templates/Ranks/newK - Copy.jpg');

    numberOfCars = 0;

    shapeNames = {'HEARTS','DIAMONDS','SPADES','CLUBS'};
    rankNames = {'A','2','3','4','5','6','7','8','9','10','J','Q','K'};

    suits = {hearts,diamonds,spades,clubs};
    ranks = {rank_A,rank_2,rank_3,rank_4,rank_5,rank_6,rank_7,rank_8,rank_9,rank_10,rank_J,rank_Q,rank_K};

    for i=1:length(suits)
        suits{i} = preprocessTemplate(suits{i});
    end

    for i=1:length(ranks)
        ranks{i} = preprocessTemplate(ranks{i});
    end
    
    threshold = graythresh(im);
     im = im2bw(im,threshold);
    
    
   imshow(newImg);
   [separations,labels] = bwlabel(im);
   
    labeledImage = logical(im);
    measurements = regionprops(labeledImage, 'BoundingBox','Orientation');
   
    for ii = 1:labels
                       
            oneregion = (separations==ii);
            
            region = regionprops(oneregion,'ConvexHull','Area','Centroid','Orientation','BoundingBox');
            
           if (region.Area <=80000)
               continue
           end

          croppedImage = imcrop(im, region.BoundingBox);
          
          [rows1, columns1, ~] = size(croppedImage);
          
          if rows1 < 1500/2 && columns1 < 1500/2
                        croppedImage = imresize(croppedImage,2.3,'bilinear');
          end
           
          angle = region.Orientation;

          uprightImage = imrotate(croppedImage, -angle+90);
          [rows, columns] = find(uprightImage);
        
          topRow = min(rows);
          bottomRow = max(rows);
          leftColumn = min(columns);
          rightColumn = max(columns);
          croppedImage_og = uprightImage(topRow:bottomRow, leftColumn:rightColumn);
        
          aa = measurements(ii).BoundingBox;
  
          fprintf('Card detected...\n')
     
          numberOfCars = numberOfCars + 1;
          [r,c] = size(croppedImage_og);
          rotateAngle = {0,180};
          
          sizeTemplate = {1,0.7};

          maxShape = 0;
          maxRank=0;

          fprintf('Template matching is starting...\n')

          %%Correlation part

            for i=1:length(rotateAngle)
                croppedImage = imrotate(croppedImage_og,rotateAngle{i});
                croppedImage = croppedImage(1:int16(r/2),1:int16(c/2));
                
                %Compute Correlation of suits

                for suitsCounter=1:length(suits)
                    for q=1:length(sizeTemplate)
                        currentShape = imresize(suits{suitsCounter},sizeTemplate{q});
                        shapeCorrelation_matrix = normxcorr2(currentShape,croppedImage);
                        shapeCorrelation = max(shapeCorrelation_matrix(:));

                         if shapeCorrelation > 0.9
                            shape = shapeNames{suitsCounter};
                            maxShape = shapeCorrelation;
                            break;
                         end
                    if (shapeCorrelation > maxShape)
                        maxShape = shapeCorrelation;
                        shape = shapeNames{suitsCounter};
                    end
                  end
                end

            %Compute Correlation of ranks 

            for ranksCounter=1:length(ranks)

                for q=1:length(sizeTemplate)

                    currentRank = imresize(ranks{ranksCounter},sizeTemplate{q});
                    rankCorrelation_matrix = normxcorr2(currentRank,croppedImage);
                    rankCorrelation = max(rankCorrelation_matrix(:));
                    if rankCorrelation > 0.9
                        maxRank =  rankCorrelation;
                        rank = rankNames{ranksCounter};
                        break;
                    end
                    if (rankCorrelation > maxRank)
                        maxRank = rankCorrelation;
                        rank = rankNames{ranksCounter};
                    end
                        
                end
                
            end
           
            end

            fprintf('Card identification is complete...\n\n')

            outputOfCard = sprintf('%s of %s', rank,shape);          
            position = [region.Centroid(1) region.Centroid(2)];
            newImg=rectangle('Position',[aa(1),aa(2),aa(3),aa(4)],'EdgeColor','r','LineWidth',3); 
            text(region.Centroid(1),region.Centroid(2),outputOfCard, 'Color', 'y','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',12,'fontweight','bold');

 
     end
       
     text_format = sprintf('Number of cards detected=%d\n',numberOfCars);
     fprintf(text_format);


function template=preprocessTemplate(im)
    im = imresize(im,1/2,'bilinear');
    threshold = graythresh(im);
    im = im2bw(im,threshold);
    template = im;
end