# Guia d'instal·lació i configuració bàsica de Borg a Debian

**ATENCIÓ AQUEST DOCUMENT S'HA CORROMPUT AMB CADENES '????', COM QUE EL PROFESSOR NO VA FER UN BACKUP HAUREU DE RECUPERAR VOSALTRES LA INFORMACIÓ PERDUDA.**


## Què és Borg?

+ Borg és un programa de backups (còpias de seguretat) que elimina dades
redundants (duplicades).

+ Aquesta darrera característica fa de Borg una eina molt adient pels backups
diaris ja que només s'emmagatzemen els canvis respecte a la versió anterior.

+ Borg també permet utilitzar compressió i xifratge autenticat.


## Instal·lació del paquet borg a Debian stable

El paquet es troba al nostre repositori de manera que fare, servir l'ordre
habitual, podem fer un `apt-get update` abans si ho considerem necessari: 


```
?????
```


## Creació d'un repositori 

###  Inicialització d'un repositori


Inicialitzem el repositori:

```
?????
```

+ la opció `-e repoquey` la veurem també com `--encription=repokey`.

+ el valor d'encriptació repokey és el recomanat si volem compatibilitat amb
  versions antigues. Altrament farem servir_authenticated_ per exemple. [Més
info.](file:///usr/share/doc/borgbackup-doc/html/usage/init.html#borg-init) 

+ La repokey, es desa al fitxer `?????` que hi ha dintre del repositori, com
  que no només necessitarem el password sinó també aquesta key, no oblidem de
copiar-la i guardar-la a un lloc segur. Si ens oblidem de copiar-la fora del
repositori, ens podem trobar amb una situació equivalent a quedar-nos fora del
cotxe tancat amb la clau a dins.

Fem un exemple de còpia de la clau, o sigui exportació,:

```
?????
```

[Més opcions en aquest enllaç](https://borgbackup.readthedocs.io/en/stable/usage/key.html#borg-key-export)

_No feu servir el format d'exportació de redirecció_ 


+ Si el repositori fos remot anàlogament faríem:

```
?????
```


### Creació de l'arxiu backup

Si fem un backup totalment físic\*, parem primer el servei, sinó podríem estem
jugant a la loteria per obtenir un backup corrupte. 

```
?????
```

+ De què volem fer backup?
	Dades de les bases de dades? Configuració?

+ On es troba aquesta info?

	Hint: com a administrador de la base de dades, puc fer servir l'ordre `show
...` per mostrar tot el que vulgui. Em puc ajudar del tabulador


	```
	?????
	```

	Creació del backup _Dijous_:

	```
	?????
	```


	És interessant observar que no hi haurà problemes amb aquest dos directoris. Es desa la ruta absoluta.

	D'aquesta manera el sistema ens mostrarà:

```
Enter passphrase for key /path/to/repo: 
Creating archive at "/path/to/repo::Dijous"
------------------------------------------------------------------------------
Archive name: Dijous
Archive fingerprint: 2ec218120706a2ccff730b94fcd51bb59f6bc47ae95ec24e0fb773a56fa7ea18
Time (start): Wed, 2022-03-30 17:47:19
Time (end):   Wed, 2022-03-30 17:47:21
Duration: 1.43 seconds
Number of files: 3937
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:              142.87 MB             29.48 MB             16.54 MB
All archives:              142.87 MB             29.48 MB             16.54 MB

                       Unique chunks         Total chunks
Chunk index:                     755                 3302
------------------------------------------------------------------------------
```

### Restauració (utilitzant l'arxiu de backup) 


Ens carreguem primer els dos directoris `/etc/postgresql/13/main/`  `/var/lib/postgresql/13/main`:

Mirem de parar el servei de postgresl

```
?????
```

Comprovem que ja no tenim accés a les bases de dades template1, training ...


Si no fem res abans el backup es farà al directori on ens trobem:



```
?????
?????
```

Ens demana la contrasenya i voilà

Engeguem el servei de postgresl i ja ens hauria de funcionar tot un altre cop


\* = parlem de backup totalment físic perquè hi ha una altra opció molt interessant que és un híbrid: fer un backup lògic amb `pg_dumpall` i després un backup físic d'aquest fitxer.


### Restauració a un dels diferents dies de Backup

+ Creem un primer backup, li direm Dilluns


	Parem el servei:

	```
	?????
	```

	Inicialitzem el repo:
	```
	?????
	```
	
	Exportem la clau per si de cas:

	```
	?????
	```

	Creem el primer backup (Dilluns)
	```
	?????
	```

+ Eliminem un registre d'una taula d'una base de dades i un altre registre
  d'una taula d'una altra base de dades

	```
	?????
	```


+ Creem un segon backup, li direm Dimarts

	Parem el servei
	
	
	```
	????
	```

	Creem el segon backup (Dimarts)
    ```
    ?????
    ```
	

+ Eliminem un registre més

	```
	?????
	```

+ Restaurem a Dimarts

	Parem el servei:
	
	``` 
	?????
	``` 
	
	Ens col·loquem a `?????` i restaurem:

	```
	?????
	```
	
	Engeguem el servei:

	```
	?????
	``` 

	Comprovem que el registre que havíem eliminat al pas anterior hi és, però
els que havíem eliminat abans de la còpia de Dilluns no.

+ Restaurem a Dilluns

	Repetir l'acció anterior


### Automatització amb borgmatic

> Borgmatic és un script fet en Python per crear/restaurar backups cridant a
Borg, permet múltiples configuracions i automatitza les tasques que fem a la
consola.


Heu de fer un vídeo _ascii_ que mostri com es fa una configuració de backup de Borg. I de restauració.

Per aconseguir això, fareu:

[Alerta! sempre instal·lem des de repositori, només si no queda més remei mirem
altres alternatives](https://wiki.debian.org/DontBreakDebian)

+ Instal·lareu el paquet asciinema (alerta! sempre instal·lem des de repositori, només sinoó queda més remei mirem altres alternatives )

+ Instal·lareu el paquet borgmatic

+ Practicareu una configuració de backup (la que volgueu) configurant els fitxers adients.

+ Gravareu les instruccions tot comentant-les amb asciinema

+ Ho pujareu a la web de [asciinema](https://asciinema.org)

+ Posareu quin és el vostre link


[Exemple d'asciinema](https://asciinema.org/a/203761)





## LINKS

+ [Manual de Borg](https://borgbackup.readthedocs.io/en/stable/)
 

 
