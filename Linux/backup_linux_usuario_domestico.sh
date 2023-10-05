#############################################
# Script para backup Linux usuário domestico
#############################################







# configuração do destino (hd externo or pendrive)



-> Criar o diretório em /mnt (como root)

mkdir -v /mnt/backup/files


-> Validar criação

ls -lhtr /mnt


-> Criar local para armazenar os logs

mkdir -v /home/usuf01/backup/log





--> Montar a mídia no diretório (com root)

# mostrar todos os devices

lsblk


-# Olhar o nome do dispositivo

mount -v /dev/sdb /mnt/backup/files


-# Confirmar (deve ver que o sdb esta montado em /mnt/backup/files)

lsblk





# Criaçao script
vi /home/usuf01/backup/script/backup_linux.sh




# Configuração da shebang (tipo de shell vai fazer a chamada debian)


#!/usr/bin/env sh



# Diretorio para fazer backup
backup_path="/home/usuf01/"


# Destino backup
dir_bkp="/mnt/backup/files"


# Formatacao do arquivo
WDT=$(date "+%Y-%-m-%-d_%H:%M-%S")

nome_arquivo="backup_$WDT.tar.gz"


# Local do log backup
dir_log="/home/usuf01/backup/log"

##########################################
# Testes de montagem do dispositivo
##########################################


# CHECK IF DEVICE IS MONTED
# -> Se o ponto de montagem não estiver ativo (! inverte a logica vai negar)

if ! mountpoint -q -- $dir_bkp; then
	printf "[$WDT] Device not mounted in:$dir_bkp check it.\n" >> %dir_log
	exit 1
fi


###########################
# Inicio do backup
###########################


--# Legenda das letras

c -> Create
z -> compressao com o gz (gunzip)
S -> Forma mais inteligente  vai fazer backup somente de conteúdo real (não irá fazer backup de espaço em branco)
p -> preservar as permissoes
f -> sempre deve vir ao final pois indica o nome do arquivo final


if  tar -czSpf "$dir_bkp/$nome_arquivo" "$backup_path"; then
	printf "[$WDT] Backup Linux successfully completed.\n" >> $dir_log
else
	printf "[$WDT] BACKUP ERROR.\n"	>> $dir_log
fi



# Exclusao backups antigos
find $dir_bkp -mtime +3 -delete





--# Permissoes ao script de backup


chmod u+x backup_linux,sh


--# para descompactar este arquivo

tar -xvf



/usr/local/sbin


# -- Agendamento crontab

crontab -e


0 23 * * * /home/usuf01/backup/script/backup_linux.sh
