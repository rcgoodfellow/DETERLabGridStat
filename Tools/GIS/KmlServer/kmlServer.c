#include<sys/types.h>
#include<sys/socket.h>
#include<stdio.h>
#include<netinet/in.h>
#include<string.h>
#include<unistd.h>
#include<stdlib.h>

#define WHITE "\e[2;37m"
#define GREEN "\e[2;32m"
#define RED "\e[1;31m"
#define NEUTRAL "\e[m"

#define BL_Q_SIZE 47

#define KML_HEAD    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"\
                    "<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n"
#define KML_TAIL    "</kml>\r\n"

int acquireSocket(int *soc);
int bindToSocket(int soc);
int shutdownSocket(int soc);
int listenToSocket(int soc);
int acceptOnSocket(int soc);
int sendReply(int soc);
int closeSocket(int soc);
int createKml(char** kml);
int placeMark(float lat, float lon, char** pm);

int main()
{
    int soc, result=0;

    if( (result = acquireSocket(&soc)) )    goto end;
    if( (result = bindToSocket(soc)) )      goto end_clean;
    if( (result = listenToSocket(soc)) )    goto end_clean;
    
    while(!result) {
        result = acceptOnSocket(soc);
    }
    goto end_clean;

    printf("Press any key to exit");
    getc(stdin);

end_clean:
   
   shutdownSocket(soc); 

end:

    return result;
}

/*****************************************************
  *
  * acquireSocket
  *
  ***************************************************/
int acquireSocket(int *soc)
{
    int result=0;
#ifdef DEBUG
   printf(WHITE "acquire socket\r\n" NEUTRAL);
#endif

    *soc = socket(PF_INET, SOCK_STREAM, 0);
    
    if(*soc < 0) {
        perror(RED "could not acquire socket" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else 
        printf(GREEN "OK (%d)\r\n" NEUTRAL, *soc);
#endif

    return result;
}

/*****************************************************
  *
  * bindToSocket 
  *
  ***************************************************/
int bindToSocket(int soc)
{
    int result=0;
    struct sockaddr_in srvAddr;

#ifdef DEBUG
    printf(WHITE "bind socket %d to port 80\r\n" NEUTRAL, soc);
#endif

    //bind to socket
    srvAddr.sin_family = AF_INET;
    srvAddr.sin_port = htons(80);
    srvAddr.sin_addr.s_addr = INADDR_ANY;
    if( bind(soc,(const struct sockaddr*)&srvAddr, sizeof(srvAddr)) ) {
        perror(RED "could not bind to socket 80" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
    return result;
}


/*****************************************************
  *
  * shutdownSocket 
  *
  ***************************************************/
int shutdownSocket(int soc)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "shutdown socket %d\r\n" NEUTRAL, soc);
#endif

    if(shutdown(soc, SHUT_RDWR) == -1) {
        perror(RED "could not shutdown socket" NEUTRAL);
        result = -1;
    }
    else {
#ifdef DEBUG
        if(closeSocket(soc)) 
            printf(GREEN "OK\r\n" NEUTRAL);
#endif
    }

    return result;

}


/*****************************************************
  *
  * closeSocket 
  *
  ***************************************************/
int closeSocket(int soc)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "closing socket descriptor %d\n\r" NEUTRAL, soc);
#endif
    if(close(soc)) {
        perror(RED "could not close socket descriptor" NEUTRAL);
        result=-1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif

    return result;
}

/*****************************************************
  *
  * listenToSocket 
  *
  ***************************************************/
int listenToSocket(int soc)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "listen to socket %d\r\n" NEUTRAL, soc);
#endif

    if( listen(soc, BL_Q_SIZE) ) {
        perror(RED "could not lesten to socket" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif

    return result;
}

/*****************************************************
  *
  * acceptOnSocket 
  *
  ***************************************************/
int acceptOnSocket(int soc)
{
    int result=0;
    int cliSock=0;
#ifdef DEBUG
    printf(WHITE "accepting on socket %d\r\n" NEUTRAL, soc);
#endif

    //dont care about who is sending request
    if( (cliSock = accept(soc, NULL, NULL)) == -1 ) {
        perror(RED "failed to accept connection" NEUTRAL);
        result = -1;
    }
    else
    {
#ifdef DEBUG
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
        sendReply(cliSock);
    }


    return result;

}


/*****************************************************
  *
  * sendReply 
  *
  ***************************************************/
int sendReply(int soc)
{
    int result=0;
    
    char* payload=NULL;
    createKml(&payload);

    int ps = strlen(payload) ;
    
    const char* head =   "HTTP/1.1 200 OK\r\n"
                        "Content-Type: text/plain\r\n"
                        "Content-Length: ";

    char payload_size[16]; 
    sprintf(payload_size, "%d", ps);
    const char* head_end = "\r\n\r\n";
    
    
    char* msg = malloc(
                             strlen(head) + 
                             strlen(payload_size) +
                             strlen(head_end) + 
                             strlen(payload) + 
                             0
                            );
    strcpy(msg, head);
    strncat(msg, payload_size, strlen(payload_size));
    strcat(msg, head_end);
    strcat(msg, payload);

#ifdef DEBUG
    printf(WHITE "sending reply on socket %d\r\n" NEUTRAL, soc);
    printf("%s", msg);
#endif

    if( send(soc, msg, sizeof(char) * strlen(msg), MSG_EOF) == -1 ) {
        perror(RED "failed to send reply to request" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
    
    free(msg);
    free(payload);
    shutdownSocket(soc);
    return result;
}

int createKml(char** kml)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "creating KML data \r\n" NEUTRAL);
#endif
    
    char* pm=NULL;
    placeMark(46.7369, -117.1809, &pm);
    
    *kml = malloc( strlen(KML_HEAD) + strlen(pm) + strlen(KML_TAIL) );
    strcpy(*kml, KML_HEAD);
    strcat(*kml, pm);
    strcat(*kml, KML_TAIL);

    free(pm);

    return result;
}

int placeMark(float lat, float lon, char** pm)
{
    char* data =    
        "<Placemark>\n"   
            "<Style>\n"
                "<IconStyle>\n"
                    "<color>ff339900</color>\n"
                    "<scale>0.5</scale>\n"
                    "<Icon>\n"
                        "<href>http://maps.google.com/mapfiles/kml/shapes/donut.png</href>\n"
                    "</Icon>\n"
                "</IconStyle>\n"
            "</Style>\n" 
            "<name>Squanto</name>\n"
            "<Point>\n"
                "<coordinates>-117.181111, 46.737158</coordinates>\n"
            "</Point>\n"
         "</Placemark>\n";

    *pm = malloc(strlen(data));
    strcpy(*pm, data);

    return 0;
}


