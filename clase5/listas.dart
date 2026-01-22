void main (){
	List numeros = [1,2,3,4];

	for(int x in numeros){
		print(x);
	}

	for(int i = 0; i < numeros.length; i++){
		print(numeros[i]);
	}

	List <String> estudiantes = ["abc","xgh"];
	for(String e in estudiantes){
		print(e);
	}

	int cont = 0;
	int suma = 0;
	do{
		suma+= ++cont;
	} while (cont<10);
	print(suma);
}
