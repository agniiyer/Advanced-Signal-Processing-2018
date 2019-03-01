function [a, b] = freq(f)
    switch f
        case 0
            a=941;
            b=1336;
        case 1
            a=697;
            b=1209;
        case 2
            a=697;
            b=1336;
        case 3
            a=697;
            b=1477;
        case 4
            a=770;
            b=1209;
        case 5
            a=770;
            b=1336;
        case 6
            a=770;
            b=1477;
        case 7
            a=852;
            b=1209;
        case 8
            a=852;
            b=1336;
        case 9
            a=852;
            b=1477;
    end
end