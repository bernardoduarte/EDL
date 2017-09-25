# Trabalho de Estrutura de Linguagens

Alunos: Vin�cius Soares, Daniel Jos�, Bernardo Duarte

# Haskell:

## Hist�ria:

Haskell tem suas principais inspira��es centradas em 2 ideias: Programa��o Funcional e Avalia��o Pregui�osa.

A Programa��o Funcional, implementada primeiramente na linguagem Lisp, tem sua origem na Programa��o Declarativa, que � um paradigma de programa��o focado em descrever logicamente o que deve ser feito por um programa sem descrever um fluxo de controle. A programa��o funcional evoluiu com a adi��o de Fun��es Lambda, e defini��es de fun��o por meio de padr�es. As linguagens das quais Haskell baseou suas id�ias de programa��o funcional foram Scheme e ML.

No lado da Avalia��o Pregui�osa, a ideia de fun��es que n�o avaliam seus par�metros imediatamente come�ou por volta dos anos 70 e, com isso, houve uma enorme quantidade de linguagens de programa��o funcionais criadas com o conceito de avalia��o pregui�osa.
Em 1987, ent�o, em uma confer�ncia sobre Programa��o Funcional, os presentes decidiram criar uma linguagem funcional unificada, pois a grande quantidade de linguagens deste estilo tornava dif�cil o compartilhamento de c�digo entre programadores, j� que n�o havia unifica��o nas linguagens e compiladores utilizados.

Com isso, eles decidiram utilizar uma linguagem existente e aprimor�-la para servir o prop�sito. A linguagem escolhida foi Miranda, por�m o criador desta linguagem n�o aceitou o pedido. Assim, foi criado um comit� daqueles que iriam desenvolver esta �linguagem unificada�, que foi nomeado �Haskell Committee�. Ent�o, o documento que determinou a cria��o da linguagem Haskell foi publicado em 1� de Abril de 1990.

## Classifica��o:

Haskell � uma linguagem funcional pura, utilizando conceitos de programa��o declarativa e de avalia��o pregui�osa como bases da linguagem. Na quest�o de estaticidade e dinamicidade, a linguagem Haskell � uma linguagem estritamente est�tica, por ter uma tipagem forte, e ser uma linguagem compilada, sem poder ser feita uma avalia��o e compila��o de c�digo durante o runtime.

A linguagem Haskell � utilizada, em geral, para tarefas com grande carga de trabalho, com uso de programa��o paralela. Tamb�m � bastante utilizada para o desenvolvimento de ferramentas. Alguns exemplos s�o o sistema de filtragem de spam do Facebook, o sistema de suporte de infraestrutura de TI da Google, e o sistema de serializa��o de dados da Microsoft, chamado Bond.

## Fun��es de Alta Expressividade:

### Tipos Alg�bricos de Dados:

Tipos Alg�bricos de Dados s�o tipos de dados que podem assumir diferentes formas dependendo do modo como eles s�o constru�dos. Eles s�o �teis para a constru��o de tipos de dados que possuem comportamento tanto complexo quanto simples, podendo haver um, nenhum ou m�ltiplos campos. Eles s�o criados pela palavra chave **data** que determina o nome do tipo, este tendo que come�ar com letra mai�scula. O comportamento desses tipos alg�bricos � definido pelos seus construtores que s�o express�es que definem os tipos que ser�o utilizados pelos seus campos. Cada construtor define um conjunto espec�fico de campos, podendo diferenciar entre construtores de um mesmo tipo alg�brico.
  
A escrita de um tipo de dado alg�brico com somente um construtor que possui um ou mais campos tem o mesmo prop�sito de uma **struct** em C, o tipo alg�brico ser� um tipo que armazena um conjunto de tipos de uma forma �nica.

```C
//Struct em C
struct Livro {
    int isbn;
    char* title;
    char** authors;
};
```

```Haskell
--Struct usando data em Haskell
data Livro = Livro Int String [String]
            deriving (Show)
```

Um tipo de dado alg�brico que possui v�rios construtores, por�m nenhum deles possui campo tem o mesmo prop�sito de uma enumera��o em C, visto que qualquer constru��o ser� do mesmo tipo alg�brico por�m cada uma possuir� seu pr�prio significado.
Caso implementado derivando a class **Eq** ser� de fato igual a uma enumera��o.

```C
//Enum em C
enum Dia {
    Domingo,
    Segunda,
    Terca,
    Quarta,
    Quinta,
    Sexta,
    Sabado
};
```

```Haskell
--Enum usando data em Haskell
data Dia
    = Domingo
    | Segunda
    | Terca
    | Quarta
    | Quinta
    | Sexta
    | Sabado
    deriving (Eq, Show)
```

O tipo de dado alg�brico permite tamb�m seu uso sem a declara��o espec�fica de tipos podendo ser declarada de forma a referenciar os tipos a partir daqueles que ser�o passados como par�metros aos construtores, essa � a forma param�trica. A equival�ncia dessa forma com C seriam os ponteiros gen�ricos e com os Templates em C++.

```C
//Void em C
struct node {
    void* data;
    struct node* next;
};
```

```Haskell
--Void em Haskell
data Lista = Vazia | Cons a (Lista a)
    deriving (Show)
```

Por fim existem os tipos recursivos. Estes, por sua vez, s�o implementados de forma a se auto referenciar dentro de um dos campos de seus construtores, surgindo ent�o uma recurs�o. Normalmente esse tipos alg�bricos recursivos s�o acompanhados de construtores Nulos, onde se � definido um construtor sem campos que serve de indicador de dado vazio. Exemplos de utiliza��o s�o listas e �rvores, estruturas de dados que inclusive possuem estruturas similares nas outras linguagens, como em C e C++ com o uso de ponteiros.

```C
//Altura de arvore em C
struct node {
    void* value;
    struct node* left, right;
};
int height(struct node* tree)
{ 
    if (tree == NULL) return 0;
    return 1 + max(height (tree->left), height (tree->right)); 
}
```

```Haskell
--Altura da arvore em Haskell
data Tree a = EmptyNode
        | Node a (Tree a) (Tree a)
        deriving (Show)
depth :: (Tree a) -> Int
depth EmptyNode = 0
depth (Node _ l r) = 1 + max (depth l) (depth r)
```

A vantagem do uso de tipos alg�bricos surge pela sua capacidade de adicionar expressividade ao c�digo, pois ao criarmos nossos tipos iremos criar uma linguagem nossa de forma a nos comunicar atrav�s da mesma dentro do pr�prio c�digo, o que gera uma **Linguagem Espec�fica do Dom�nio**.

Outra grande utilidade vem por garantir opera��es com seguran�a de tipagem, onde em tempo de compila��o o compilador ser� capaz de determinar se existem erros dentro do seu c�digo. Ent�o, mesmo que sejam utilizadas abstra��es de tipos como Num, se for feita uma implementa��o utilizando Int, junto com Float, o compilador conseguir� descobrir e alertar� ao programador sobre o erro. Isso se d� por causa da sua capacidade de implementar tipos **gen�ricos**.

### Gen�ricos

A defini��o de vari�vel gen�rica � uma vari�vel que aceita valores de quaisquer tipos, sem restringir a uma defini��o de tipo espec�fica. No caso de Haskell, tipos de dado gen�ricos s�o determinados pelo tipo **data**. A ideia de gen�ricos em Haskell tamb�m � diferente a de outras linguagens de programa��o pois, em Haskell, tipos gen�ricos s�o feitos por meio de polimorfismo. O tipo **data** determina um tipo que aceita qualquer valor. Por exemplo, uma lista de **data** pode aceitar qualquer valor, de inteiros a fun��es, e at� outras listas. H� tamb�m a possibilidade de limitar os dados que podem ser atribu�dos a uma declara��o de tipo gen�rica, utilizando a ideia de tipos alg�bricos de dados.

As fun��es s�o naturalmente gen�ricas, j� que o compilador assume que, caso n�o haja uma declara��o direta de tipo, os atributos s�o do tipo mais gen�rico poss�vel. Portanto, se uma fun��o � declarada usando apenas pattern matching como checagem de atributo, a fun��o executaria corretamente com qualquer tipo que fosse passado.

#### Exemplos:

O seguinte trecho de c�digo, em Haskell, define um tipo lista gen�rica, cria duas listas, uma contendo 1,2,3 e outra contendo 4,5,6, define uma fun��o **unir** que faz a uni�o das duas listas e retorna uma lista unida, e depois imprime na tela a lista unida.

```Haskell
--Uniao de listas em Haskell
infixr 5 :-:
data Lista a = Vazio | a :-: (Lista a) deriving (Show)
unir :: Lista a -> Lista a -> Lista a
unir Vazio ys = ys
unir (x :-: xs) ys = x :-: (unir xs ys)
l1 = 1:-:2:-:3:-:Vazio
l2 = 4:-:5:-:6:-:Vazio
main :: IO ()
main = do let result = (unir l1 l2)
          putStrLn(show result)
```

O seguinte trecho de c�digo, em C++, � similar ao de Haskell, definindo uma classe de lista gen�rica, com a fun��o **join** que faz a uni�o de duas listas, adicionando a segunda lista ao fim da primeira, e depois imprime na tela a lista unida.

```C++
//Uniao de listas em C++
#include <iostream>

template <typename T>
class Lista {
public:
    struct No {
    public:
        T dado;
        No* prox;
    };
    No* inicio;
    int tamanho;

    Lista() {
        inicio = nullptr;
        tamanho = 0;
    }

    Lista(int vet[], int tam) {
        for (int i = 0; i < tam; i++) {
            append(vet[i]);
        }
        tamanho = tam;
    }

    void append(T elem) {
        No* atual = inicio;
        for (int i = 1; i < tamanho; i++) {
            atual = atual->prox;
        }
        No* no = new No();
        no->dado = elem;
        no->prox = nullptr;
        if (tamanho == 0) {
            inicio = no;
        }
        else {
            atual->prox = no;
        }
        tamanho++;
    }

    void join(Lista l) {
        if (l.tamanho == 0) {
            return;
        }
        No* atual = inicio;
        for (int i = 1; i < tamanho; i++) {
            atual = atual->prox;
        }
        atual->prox = l.inicio;
        tamanho = tamanho + l.tamanho;
    }

    friend std::ostream& operator<<(std::ostream& os, const Lista<T>& lista) {
        No* atual = lista.inicio;
        os << atual->dado;
        for (int i = 1; i < lista.tamanho; i++) {
            os << ",";
            atual = atual->prox;
            os << atual->dado;
        }
        return os;
    }
};

int main(void) {
    int vet1[] = { 1,2,3 };
    int vet2[] = { 4,5,6 };
    Lista<int> l1(vet1, 3);
    Lista<int> l2(vet2, 3);
    l1.join(l2);
    std::cout << l1 << std::endl;
}
```
Comparando estes 2 trechos, � vis�vel que, no exemplo de Haskell, o c�digo � bem mais conciso, e requer bem menos defini��es, pelo fato da lista ser composta por meio de pattern matching, e a defini��o da lista � bem mais simples, pelo uso de tipos alg�bricos e do tipo **data**. Em C++, � necess�rio o uso de Templates para que seja feito a mesma defini��o de lista e, mesmo se removendo toda a parte defini��o em si da lista, ainda seriam mais complexos tanto a defini��o da lista quanto a instancia��o da mesma. Portanto, mesmo o c�digo em C++ sendo mais facilmente entend�vel por meio da leitura, � mais complexo em sua escrita, por necessitar de constantes declara��es de Templates.

Sobre fun��es gen�ricas, o seguinte trecho de c�digo, em Haskell, define a fun��o **troca** como uma fun��o que pega uma tupla e cria uma nova tupla com a ordem dos valores trocada.

```Haskell
--Troca em Haskell
troca (x,y) = (y,x)
val1 = 1
val2 = 2
val3 = 'a'
val4 = [1,2,3]
main :: IO()
main = do let result = (troca(val1,val2))
          putStrLn(show result)
          let result = (troca(val2,val3))
          putStrLn(show result)
          let result = (troca(val3,val4))
          putStrLn(show result)
          
```

O seguinte trecho de c�digo, em C++, faz algo similar ao de Haskell, recebendo um par definido por um **struct** e usando templates para fazer a fun��o ser gen�rica.

```Cpp
//Troca em C++
#include <iostream>

template <typename T, typename G>
struct par {
    T um;
    G dois;
};

template <typename T, typename G>
par<G,T> troca (par<T,G> p) {
    par<G,T> pInv;
    pInv.um = p.dois;
    pInv.dois = p.um;
    return pInv;
}

int main(void) {
    par<int,int> par1;
    par1.um = 1; par1.dois = 2;
    par1 = troca(par1);
    std::cout << "(" << par1.um << ", " << par1.dois << ")";
    par<int,char>par2;
    par2.um = 1; par2.dois = 'a';
    par<char,int>par3;
    par3 = troca(par2);
    std::cout << "(" << par3.um << ", " << par3.dois << ")";
    par<char,int*>par4;
    int vet[] = {1,2,3};
    par4.um = 'a'; par4.dois = vet;
    par<int*,char>par5;
    par5 = troca(par4);
    std::cout << "(" << par5.um << ", " << par5.dois << ")";
}
```

Portanto, h� uma grande diferen�a, pois em C++ s�o necess�rias v�rias defini��es de templates diferentes, e v�rios usos de templates, para fazer as mesmas opera��es que, em Haskell, s�o apenas definidas por meio de uma defini��o de l�gica. Por isso, Haskell possui muito mais redigibilidade neste ponto, por ter c�digos muito mais concisos, mas h� alguma perda de legibilidade. Por�m, a l�gica de entendimento das fun��es gen�ricas em Haskell � bem mais direta do que em C++, aumentando assim a expressividade da linguagem neste ponto. 

### Tipos e Fun��es Polim�rficas:

Polimorfismo � a ideia de criar um tipo �mais gen�rico� que engloba um ou mais tipos �mais especializados�, para que seja feito o armazenamento e a passagem de argumentos com o tipo �mais gen�rico�, e que opera��es sejam feitas sobre os tipos �mais especializados�, simplificando assim o c�digo escrito por fora das fun��es.

Em Haskell, � poss�vel fazer tipos polim�rficos, por meio do uso do conceito de Gen�ricos e de Tipos Alg�bricos de Dados. Com a utiliza��o de um tipo **data** limitado por defini��es alg�bricas, podem ser feitas fun��es ou estruturas de dados que recebem um tipo �mais gen�rico� que posteriormente pode ser reconhecido como um tipo �mais especializado� e ter opera��es feitas sobre ele. Polimorfismo � uma parte intr�nseca da defini��o da linguagem Haskell, e portanto � simples e intuitivo de ser utilizado, apenas necessitando de checagens alg�bricas em todos os pontos em que polimorfismo seria utilizado.

#### Exemplos:

No seguinte trecho de c�digo em Haskell, � definido o tipo Forma, que pode ser tanto um Tri�ngulo, quanto um Ret�ngulo, quanto um Quadrado, cada um com seu pr�prio construtor, definido pelos tipos alg�bricos. Ent�o, o programa gera um Tri�ngulo, um Quadrado e um Ret�ngulo, e usa a defini��o da fun��o polim�rfica area para calcular a �rea de cada uma das formas, utilizando a mesma chamada de fun��o para cada uma.

```Haskell
--Polimorfismo de Forma em Haskell
data Forma = Triangulo Float Float | Retangulo Float Float | Quadrado Float
area :: Forma -> Float
area (Triangulo x y) = (x*y)/2
area (Quadrado x) = x*x
area (Retangulo x y) = x*y
t = Triangulo 3 5
r = Retangulo 5 10
q = Quadrado 3
main = do let result = (area(t))
          putStrLn(show result)
          let result = (area(r))
          putStrLn(show result)
          let result = (area(q))
          putStrLn(show result)
```

Por outro lado, o mesmo c�digo em C++ necessita da defini��o de classes, e n�o � poss�vel realmente fazer uma fun��o gen�rica capaz de descobrir se a forma passada � um ret�ngulo, quadrado ou tri�ngulo e calcular a �rea deste, mas � poss�vel fazer uma classe �pai� que cont�m o m�todo abstrato area(), e depois implementar um area() para cada uma das diferentes formas, para por fim poder executar o comando area() de um ponteiro para Forma, fazendo o m�todo calcular corretamente a �rea da forma.

```Cpp
//Polimorfismo de Forma em C++
#include <iostream>

class Forma {
    public:
         virtual float area() = 0;
};
class Triangulo : public Forma {
    public:
        float base;
        float altura;
        Triangulo(float b, float a) {
            base = b;
            altura = a;
        }
        float area() {
            return (base*altura)/2;
        }

};
class Retangulo : public Forma {
    public:
        float compr;
        float altura;
        Retangulo(float c, float a) {
            compr = c;
            altura = a;
        }
        float area() {
            return compr * altura;
        }
};
class Quadrado : public Forma {
    public:
        float lado;
        Quadrado(float l) {
            lado = l;
        }
        float area() {
            return lado * lado;
        }
};
int main(void) {
    Triangulo t(3, 5);
    Retangulo r(5, 10);
    Quadrado q(3);
    Forma* f[3];
    f[0] = &t;
    f[1] = &r;
    f[2] = &q;
    for (int i = 0; i < 3; i++) {
        std::cout << f[i]->area() << std::endl;
    }
}
```

Portanto, em C++, al�m do c�digo ser mais longo, � mais complexo de ser lido, e a l�gica por tr�s � bem mais complexa, por necessitar de conceitos como heran�a de classes e fun��es/classes virtuais.

### Avalia��o Pregui�osa:

Haskell � uma linguagem que usa a estrat�gia de lazy evaluation ao avaliar express�es. Essa estrat�gia, conhecida tamb�m como call-by-need, consiste em apenas calcular o valor de uma express�o quando seu valor realmente � necess�rio. Isso evita que sejam realizados c�lculos desnecess�rios, pois mesmo um valor passado a uma fun��o, quando n�o utilizado, n�o � calculado.

Por exemplo, se um c�digo semelhante ao trecho de c�digo abaixo fosse rodado em uma linguagem que n�o usa a avalia��o pregui�osa, o programa nunca pararia, mas como o argumento problem�tico nunca � utilizado o programa roda sem problemas.

```Haskell
--Funcao "infinita" em Haskell
funcao x y = x
a = funcao 10 [1,2,..]
```

Torna-se poss�vel, portanto:
* Definir estruturas infinitas.
* Definir suas pr�prias express�es de fluxo de controle.

Em contrapartida, a legibilidade do c�digo � prejudicada ao realizar esse tipo de avalia��o pois, ao se ler o c�digo, n�o se consegue determinar com facilidade em que parte do c�digo uma express�o est� realmente sendo calculada. Al�m disso, podem acontecer casos onde o custo para se armazenar uma express�o pode superar de maneira consider�vel o custo para se armazenar o resultado dela, o que pode causar problemas de armazenamento de mem�ria que n�o s�o facilmente detect�veis.

#### Fluxo de Controle:

Na linguagem C n�o podemos redefinir express�es de fluxo de controle como, por exemplo, o if, sem utilizar o if.

Em Haskell, diferentemente de C, podemos definir utilizando pattern matching uma estrutura que age de maneira semelhante:

```Haskell
--Redefinicao do if em Haskell
if' True x _ = x
if' False _ y = y 
```

#### Listas Infinitas:

Gra�as a essa estrat�gia podemos, portanto, definir uma lista de tamanho infinito. Com essa facilidade, podemos simplesmente definir as regras para a gera��o de uma sequ�ncia em vez de precisarmos gerar os valores que usaremos individualmente antes mesmo de utiliz�-los.

Podemos, por exemplo, expressar a sequ�ncia de fibonacci como uma sequ�ncia recursiva infinita.

```Haskell
--Fibonacci em Haskell
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
```

Por causa da maneira que o Haskell guarda as express�es na mem�ria, esse fibonacci tamb�m possui memoriza��o.

Ao utilizarmos essa sequ�ncia como argumento de alguma outra fun��o, (contanto que essa opera��o seja finita, j� que fun��es que dependem apenas da lista infinita como a fun��o length n�o podem ser utilizadas nesse tipo de lista) a opera��o s� calcular� os valores da sequ�ncia que forem necess�rios.

```Haskell
--Fibonacci completo em Haskell
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
lista = [1,2,3,4,5]
resultado = zipWith (*) lista fibs
```

Para fazer uma fun��o semelhante em C, � necess�rio calcular primeiro um vetor com os valores da sequ�ncia necess�rios ou ent�o utilizar parte de um vetor de memoriza��o j� preenchido, tornando o c�digo bem mais extenso e at� mesmo mais dif�cil de entender.

```C
//Fibonacci em C
void fib(int* table,int n) 
{
    table[0] = table[1] = 1;
    for (int i = 2; i <= n; ++i) {
        table[i] = table[i-1] + table[i-2];
    }
}

int main(void){
    int n = 20;
    int table[n+1];
    fib(&table,n);
    int vetor[] = {1,2,3,4,5};
    int tamvetor = 5;
    int resultado[tamvetor];
    for (int i = 0;i < tamvetor;i++){
        resultado[i] = vetor[i] * table[i];
    }
}
```

### Compreens�o de Listas:

Compreens�o de lista � um tipo de sintaxe presente em Haskell que permite criar listas utilizando outras listas j� existentes. Ela se inspira na nota��o matem�tica de conjuntos.

Se quis�ssemos uma lista das pot�ncias de dois por exemplo. Em C, utilizamos um loop para criar um vetor com um n�mero finito de pot�ncias, 

```C
//Potencias de vetor em C
void potencias(double vet[],int tamanho){
    for(unsigned int i = 0;i < tamanho; i++){
        vet[i] = pow(2.0,i);
    }
}

int main(void){
    double vet[20];
    potencias(vet,20);
    printf("%f",vet[10]);
}
```

mas utilizando compreens�o de listas e listas infinitas podemos simplesmente definir a seguinte lista:

```Haskell
--Potencias de Lista Infinita em Haskell
potencias = [2**x | x <- [0..]]
```

Para retirar as mesmas 20 pot�ncias do exemplo em C podemos simplesmente utilizar a fun��o take:

```Haskell
--Potencias de Lista Infinita em Haskell
conjunto = [2**x | x <- [0..]]
potencias = take 20 conjunto
```

Podemos tamb�m aninhar quantas condi��es quisermos na gera��o de uma lista, utilizar mais de uma lista j� existente para gerar nossa lista e ainda declarar vari�veis que utilizaremos utilizando a palavra reservada let.

```Haskell
--Uso de let para conjunto em Haskell
conjunto = [z | x <- [1..20], y <- [1..20] , let z = x*y, z /= 13, z /= 17, z /= 19, z `mod` 3 /= 0, z `mod` 7 /= 0]  
```

O exemplo mais conhecido por demonstrar a expressividade das compreens�es de lista � o quicksort.

```C
//Quicksort em C
void quicksort0(int arr[], int a, int b) {
    if (a >= b)
        return;

    int key = arr[a];
    int i = a + 1, j = b;
    while (i < j) {
        while (i < j && arr[j] >= key)
            --j;
        while (i < j && arr[i] <= key)
            ++i;
        if (i < j)
            swap(arr, i, j);
    }
    if (arr[a] > arr[i]) {
        swap(arr, a, i);
        quicksort0(arr, a, i - 1);
        quicksort0(arr, i + 1, b);
    } else {
        quicksort0(arr, a + 1, b);
    }
}
```

Fazendo uso da compreens�o de listas podemos fazer o quicksort em apenas duas linhas:

```Haskell
--Quicksort em Haskell
quicksort [] = []  
quicksort (x:xs) = quicksort [a | a <- xs, a <= x] ++ [x] ++ quicksort [a | a <- xs, a > x]  
```

Podemos ver, portanto que utilizando esse recurso o c�digo se torna mais f�cil de escrever e at� mesmo mais f�cil de ler. Vemos tamb�m o poder expressivo desse recurso, j� que a implementa��o do algoritmo do quicksort em haskell � muito mais pr�ximo de como se explicaria o algoritmo em linguagem natural do que a vers�o em C.

## Bibliografia:
1. https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/history.pdf?from=http%3A%2F%2Fresearch.microsoft.com%2F~simonpj%2Fpapers%2Fhistory-of-haskell%2Fhistory.pdf
2. https://wiki.haskell.org/ 
3. http://www.cs.ox.ac.uk/jeremy.gibbons/publications/dgp.pdf
4. https://stackoverflow.com/questions/9558804/quick-sort-in-c
5. https://hackhands.com/lazy-evaluation-works-haskell/
6. http://learnyouahaskell.com/
7. https://wiki.haskell.org/The_Fibonacci_sequence#Using_the_infinite_list_of_Fibonacci_numbers
8. http://zvon.org/other/haskell/Outputprelude/zipWith_f.html
9. https://en.wikipedia.org/wiki/Lazy_evaluation
10. https://wiki.haskell.org/Lazy_evaluation
11. https://hackhands.com/modular-code-lazy-evaluation-haskell/
12. https://en.wikibooks.org/wiki/Haskell/GADT
13. https://kuniga.wordpress.com/2011/09/25/haskell-tipos-de-dados-algebricos/
14. https://stackoverflow.com/questions/29882155/improve-c-fibonacci-series