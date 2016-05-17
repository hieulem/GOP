function col=GiveAColour(no)

switch (mod(no-1,8)+1)
    case 1
        col= 'r';
    case 2
        col= 'm';
    case 3
        col= 'c';
    case 4
        col= 'y';
    case 5
        col= 'b';
    case 6
        col= 'g';
    case 7
        col= 'k';
    case 8
        col= 'w';
end

