#include<cstdlib>
#include <iostream>
#include <algorithm>
#include <vector>
#include<iterator>
#include<ctime>
#define endl "\n"
#define MAX_SIZE 3
using namespace std;
main()
{
    char choice = '0';
    int id;    //contact index
    string nameList[MAX_SIZE];
    string no1List[MAX_SIZE];
    string no2List[MAX_SIZE];
    string name;    //to search
    int size=0;
    int ptrName = 0;    //to add in empty blocks
    disp:
    cout<<endl<<"--------------------------------------------------------------"<<endl;
    cout<<"Phone Book"<<endl;
    cout<<"(1) Add a new contact"<<endl;
    cout<<"(2) Delete a contact"<<endl;
    cout<<"(3) Add a second number to an existing contact"<<endl;
    cout<<"(4) Delete a number from an existing contact"<<endl;
    cout<<"(5) Query on a number"<<endl;
    cout<<"(6) Show all contacts"<<endl;
    cout<<"(7) Exit"<<endl;

    loop1:
        cout<<"Enter ur choice: ";
        cin>>choice;

    cout<<"--------------------------------------------------------------"<<endl;
    //////////////////////////////////////////////////////////////////////
    if(choice<'1')
        goto loop1;
    if(choice>'7')
        goto loop1;
    //////////////////////////////////////////////////////////////////////
    if(choice=='1')
        goto one;
    if(choice=='2')
        goto two;
    if(choice=='3')
        goto three;
    if(choice=='4')
        goto four;
    if(choice=='5')
        goto five;
    if(choice=='6')
        goto six;
    if(choice=='7')
        goto exit;
    //////////////////////////////////////////////////////////////////////
    one:    //Add a new contact
        if(size==MAX_SIZE)
            goto failed;
        ptrName = 0;

        loop2:
        if(nameList[ptrName]!="")
        {
            ptrName++;
            goto loop2;
        }
        cout<<"Enter name: ";
        cin>>nameList[ptrName];
        cout<<"Enter no1: ";
        cin>>no1List[ptrName];
        size++;
        goto disp;

    //////////////////////////////////////////////////////////////////////
    two:    //Delete a contact
        if(size==0) //empty list
            goto failed;

        cout<<"Contacts"<<endl;
        for(int i=0;i<MAX_SIZE;i++)
        {
           if(nameList[i]=="")
                continue; //goto for loop

           cout<<"("<<i+1<<") "<<nameList[i]<<endl;
        }
        cout<<"Delete no.: ";
        cin>>id;
        id--;
        nameList[id]="";
        no1List[id]="";
        no2List[id]="";
        size--;
        cout<<"Deleting..."<<endl;
        goto disp;

    //////////////////////////////////////////////////////////////////////
    three:  //Add a second number to an existing contact
        if(size==0) //empty list
            goto failed;

        cout<<"Contacts"<<endl;
        for(int i=0;i<MAX_SIZE;i++)
        {
           if(nameList[i]=="")
                continue; //goto for loop

           cout<<"("<<i+1<<") "<<nameList[i]<<endl;
        }
        cout<<"Contact no.: ";
        cin>>id;
        id--;
        if(nameList[id]=="") //empty name
            goto one;
        cout<<"Enter no2: ";
        cin>>no2List[id];
        cout<<"Adding..."<<endl;
        goto disp;

    //////////////////////////////////////////////////////////////////////
    four:   //Delete a number from an existing contact
        if(size==0) //empty list
            goto failed;

        cout<<"Contacts"<<endl;
        for(int i=0;i<MAX_SIZE;i++)
        {
           if(nameList[i]=="")
                continue; //goto for loop

           cout<<"("<<i+1<<") "<<nameList[i]<<endl;
        }
        cout<<"Contact no.: ";
        cin>>id;
        id--;
        if(nameList[id]=="") //empty name
            goto one; //add contact
        cout<<"No.1 or No.2: ";
        cin>>choice;
        if(choice=='1')
            no1List[id]="";
        if(choice=='2')
            no2List[id]="";
        cout<<"Deleting..."<<endl;
        choice = '0';
        goto disp;

    //////////////////////////////////////////////////////////////////////
    five:   //Query on a number
        if(size==0) //empty list
            goto failed;

        cout<<"Contact Name: ";
        cin>>name;
        int i;
        for(i=0;i<MAX_SIZE;i++)
        {
           if(nameList[i]==name)
                break;
        }

        if(i==MAX_SIZE)
            goto failed;

        cout<<"("<<i+1<<") Name: "<<nameList[i]<<endl;
        cout<<"    No.1: "<<no1List[i]<<endl;
        cout<<"    No.2: "<<no2List[i]<<endl<<endl;
        goto disp;


    //////////////////////////////////////////////////////////////////////
    six:    //Show all contacts
        if(size==0) //empty list
            goto failed;

        cout<<"Contacts"<<endl;
        for(int i=0;i<MAX_SIZE;i++)
        {
           if(nameList[i]=="")
                continue; //goto for loop
           cout<<"("<<i+1<<") Name: "<<nameList[i]<<endl;
           cout<<"    No.1: "<<no1List[i]<<endl;
           cout<<"    No.2: "<<no2List[i]<<endl<<endl;
        }
        goto disp;

    //////////////////////////////////////////////////////////////////////
    failed:
        cout<<"## FAILED";
    goto disp;
    exit:;
}
