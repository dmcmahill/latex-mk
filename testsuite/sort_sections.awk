
function print_lines() {
    if(line_cnt == 0) { return; }
    hsort(lines, line_cnt);
    for(i=1; i in lines; i = i + 1) {
        print lines[i];
    }
}

function hsort(A, n, i) {
    for (i = int(n/2); i >= 1; i--)
         { heapify(A, i, n) }
    for (i = n; i > 1; i--) {
         { swap(A, 1, i) }
         { heapify(A, 1, i-1) }
    }
}
function heapify(A, left, right, p, c) {
    for (p = left; (c = 2*p) <= right; p = c) {
        if (c < right && A[c+1] > A[c])
            { c++ }
        if (A[p] < A[c])
            { swap(A, c, p) }
    }
}
function swap(A, i, j, t) {
    t = A[i]; A[i] = A[j]; A[j] = t
}

BEGIN {
    line_cnt = 0;
    first = 1;
}

$1 == "tgif" || $1 == "fig2dev" {
    key = $1;
    if( (key != key_last) && (first == 0)) {
        print_lines();
        line_cnt = 0;
        delete lines; 
    }
    line_cnt = line_cnt + 1;
    lines[line_cnt] = $0;
    key_last = key; 
    first = 0;
    next;
}

{
    print_lines();
    line_cnt = 0;
    delete lines; 
    first = 1;
    print;
    next;
}

END {
    print_lines();
}
