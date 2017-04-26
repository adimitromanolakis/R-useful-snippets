#include <unistd.h>
#include <stdio.h>
#include <string.h>



ssize_t read (int fd, void *buf, size_t count);



main ()
{

    int n = 128;
    char buf[10000];

    signed short int *b = (short int *) buf;

    signed short int b2[10000];

    int l = 100;

    while (l) {

        l = read (0, buf, n * 2);

        fprintf (stderr, "%d\n", l);

        //fprintf(stderr, "%d\n" ,  (int) b[0] );

        l = l / 2;

        for (int i = 0; i < l; i++) {

            //b[i] = 0.5*b[i];

        }


        b2[0] = b[0];
        b2[1] = b[1];

        for (int i = 2; i < l; i += 2) {

            b2[i] = 0.5 * ((float) b[i] + b[i - 2]);
            b2[i + 1] = 0.5 * ((float) b[i + 1] + b[i - 1]);


        }

        //memcpy(b2,b, 2*l);


        write (1, (char *) b2, l * 2);

    }


}
