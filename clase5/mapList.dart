void main () {
	List<Map <String,dynamic>> personas = [
		{"nombre": "karl","edad":33,},
		{"edad":22},
	];
	print("Nombre ${personas[0]['nombre']}");	
	print ("Edad ${personas[0]['edad']}");
	for(dynamic x in personas[0].entries){
		print(x);
	}
}
