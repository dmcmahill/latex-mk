#!/usr/bin/awk -f

BEGIN {
    uc=1;
}

{
    n=$1;
    for( i=1; i<=length(n); i++) {
        c=substr(n, i, 1);
        if (c ~ /-/ ) { uc = 0; }
        if(uc) {
            c = toupper(c);
            uc=0;
        } else {
            uc=1;
        }
        printf("%s", c);
    }
}

