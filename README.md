# phoneBook


phoneBook is contacts handler to save your contacts and mange them easily by friendly command line interface. It is written by Assembly (NASM). 

## Getting Started

Assembly material is very rare (videos,writeup,errors). No one counter the errors we have, we search a lot without any hope. We find one project talking about phoneBook in assembly but unfortunately it is written by MASM assembly not NASM assembly. Most of project function we write it from scratch without using any external libraries. Most of the project build from scratch and you will not find resources for it in the internet. We put a lot of comments and will try to help you as mush we can to understanding the project. So we hope README will help you in this hard journey. All the functions are dependent in each others and mainly dependent on the correct order of using this function. So listen carefully to README instructions and comments.
if you search for phoneBook (MASM) assembly that is not the right place for you. here is resource help you in this journey. GOOD LUCK! <br />

http://www.dailyfreecode.com/Code/phonebook-3542.aspx 

if you looking for phoneBook (NASM) Assembly this the right place for you. Welcome!

### Prerequisites

first, you need to update your system

```
sudo apt-get update -y
```

then, you need to install NASM to build and run the code.
you need to type this command in your terminal (for linux users only).

```
sudo apt install nasm
```

### Downloading

you don't need to download the whole repository. You just need to PhoneBook.asm to Build and run the program. However the rest of the repository it is build phases of the program. we build it in phases small functions in small programs. we will leave this small programs for you to learn from it. 

you need to type this command in your terminal to download repository.

```
git clone https://github.com/moramadan98/phoneBook
```

### Build and run

After you download the repo you need to go to repo directory by the terminal
you can do it by the next command

```
cd phoneBook
```

now all you need to (Build and run) PhoneBook.asm by the next command (CAUTION! We assume you have already install NASM)

```
nasm -felf64 PhoneBook.asm && ld PhoneBook.o && ./a.out
```

Voila! now you have the program running in your terminal.

## Running the tests

### Build and run
Intro message when you run the program showing your options in the program and you have to choose.
![Build and run](https://i.ibb.co/YXx0Hs4/image.png)

### 1- Add new contact

In this option we add new contact in the program and the program store it in your storage (Don't Worry if the program is close. We store Every thing for you)

![Add new contact](https://i.ibb.co/r5pXtbz/image.png)

notice that some files now appear

![new files create](https://i.ibb.co/JcwZvV9/image.png)

Don't worry the program save your contacts by this new files

### 2- Display all contacts

In this option we display all contacts you ever add. 

![Display all contacts](https://i.ibb.co/Js34b7b/image.png)


### 3- Search in contacts

In this option we display the contact you search for by typing the whole name.
After that the program will display the contact and its numbers (it can be more than one number!).
if contact not found it will show not Found error.

![Search in contacts](https://i.ibb.co/cXPBh2M/image.png)



### 4- Add number to existing contact

To add new number to exist contact you need to enter this contact name at the first. Then enter the new number.
If contact not found it will show not found error.

![Add number to existing contact](https://i.ibb.co/0XkZ9K4/image.png)

now search again to see the number

![results of search after add number](https://i.ibb.co/4gzHHFV/image.png)

Voila! now you have 2 numbers in one contact. You can add more without limit.

### 5- Delete one number from contact

To remove one number from contact you need to enter this contact name at the first. The program will display all numbers this contact have. You need to type one of them to remove it.

If contact not found it will show not found error.

![Delete one number from contact](https://i.ibb.co/dW1c0zJ/image.png)


now search again to see the number
![results of search after add number](https://i.ibb.co/NWcs16R/image.png)

Done number removed ^_^

### 6- Delete contact

To remove one of your contacts you need to enter this contact name.

If contact not found it will show not Found error.


![Delete contact](https://i.ibb.co/6ZcN6BN/image.png)

now display

![Display contacts after delete number](https://i.ibb.co/R4VVF4r/image.png)

as you see we have 2 empty lines here. Why?
Because when we delete we leave empty line there. If we have 2 empty lines so we have 2 Deleted contacts

### 0- Exit

If you don't have any choice just exit. Notice that: The program call itself again and again until infinity or you can just write 0 in your choice and program will terminate itself

![Exit](https://i.ibb.co/GPL7MJj/image.png)


### some notices 

contacts appear in file called contacts.txt there are empty lines (which we explain before when contact delete it leave empty line in its place)

![Content of contacts.txt and display all the contacts in it](https://i.ibb.co/3rL4dpf/image.png)

every contact has its own file called (name_of_this_contact) and have all numbers of the contact (number by every line). notice that: we have one empty line here in numbers too. it is a sign for us to know there was a number in the first line but we delete it. When the number delete it leave empty line in its place just like contacts.

example Amr in the next photo

![Content of Amr and display all the numbers in it](https://i.ibb.co/QK6xk4n/image.png)
