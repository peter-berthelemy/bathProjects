%Show me each file one by one
%   Would be nice to have a more streamlined version of this
%Make me check if its cloudy or not (C/N)
%Put it in the correct folder 
%Show next image

%UP THE CONTRAST FOR NEXT RUN
location = 'sutherland';
% path = fullfile('C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\StructuredData', location, '\');
% imPath = ('C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\StructuredData\colombia\');
% addpath('C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\StructuredData\colombia\');
path = 'C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\millstone\millstoneTrain';
imPath = path;
addpath(path);
a = dir(fullfile(imPath, '*.data.mat'));
% namey = 'C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\aTrain\';
% b1 = dir(namey);
% start = [0, 0];

% for x = 3:4
%     in  = dir(fullfile(namey, b1(x).name));
%     phill = natsortfiles({in(3:end).name});
%     palce = char(phill(end));
%     idx = strfind(palce, '.png');
%     
%     start(x-2) = str2num(palce(22:idx-1));
% end

figure
% for g = 1:length(a)
for g = 72:length(a)

    image = load(a(g).name);     
    for imageNum = 1:2:size(image.Airglow, 3)
        a(g).name
        data = image.Airglow(100:400,100:400,imageNum);
        bee = mat2gray(data);
        movegui('west')
        sqlat(data)
%         set(gcf, 'Position', get(0, 'Screensize'));

        coRn = input ('good(1), bad(2), Stripe(3), Moon(4), p Moon(5), Snow(6), Black(7), Misc.(8), Stars(9)', 's')
        p = get(gcf, 'CurrentCharacter');
        switch coRn
            case "1"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\millstone\millTrain\good\' a(g).name num2str(imageNum) '.png'])
            case "2"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\millstone\millTrain\bad\' a(g).name num2str(imageNum) '.png'])
            case "3"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\stripe\' a(g).name num2str(imageNum+start(3)) '.png'])
            case "4"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\moon\' a(g).name num2str(imageNum+start(4)) '.png'])
            case "5"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\pmoon\' a(g).name num2str(imageNum+start(5)) '.png'])
            case "6"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\snow\' a(g).name num2str(imageNum+start(6)) '.png'])
            case "7"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\black\' a(g).name num2str(imageNum+start(7)) '.png'])
            case "8"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\misc\' a(g).name num2str(imageNum+start(8)) '.png'])
            case "9"
                imwrite(bee, ['C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\trainmore\stars\' a(g).name num2str(imageNum+start(9)) '.png'])

        end
        close gcf
        clear data coRn p
    end
end