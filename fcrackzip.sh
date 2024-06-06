#!/bin/bash
#
#----------------------------------------------------------
# Fcrackzip
#
# Fcrackzip adalah alat peretas kata sandi untuk file ZIP
# yang menggunakan dua teknik: Brute-Force Attack dan
# Dictionary Attack. Dalam Brute-Force Attack, penyerang
# mencoba semua kombinasi kata sandi hingga menemukan yang
# benar. Dalam Dictionary Attack, penyerang menggunakan
# wordlist yang berisi kata sandi umum.
#
# Fcrackzip dikembangkan oleh Marc Lehmann, seorang programmer
# yang terkenal dalam komunitas perangkat lunak bebas dan
# open-source. Alat ini pertama kali dirilis pada tahun 2000.
# Ide di balik fcrackzip adalah untuk menyediakan alat yang
# cepat dan efisien untuk menebak kata sandi file ZIP, yang
# sering digunakan untuk kompresi dan enkripsi file.
#----------------------------------------------------------
# ┌  ┐
# └  ┘

b="\e[1;34m"
p="\e[1;37m"
m="\e[1;31m"
h="\e[1;32m"
r="\e[0m"

clear

# Fungsi untuk memasukkan file ZIP
function mfz(){
        while true; do
		echo -e "${b}┌(${m}Fcrackzip${b})-[ ${p}Masukkan nama file ZIP ${b}]"
                read -p $'\e[1;34m└\e[1;31m# \e[1;37m' fz
                if [[ ! -z "${fz}" ]]; then
                        if [[ -f "${fz}" ]]; then
                                if [[ "${fz##*.}" == "zip" ]]; then
                                        echo -e "${h}[${p}+${h}] ${p}File ZIP '${h}${fz}${p}' ditemukan.${r}"
                                        break
                                else
                                        echo -e "${m}[${p}-${m}] ${p}File '${m}${fz}${p}' bukan file ZIP.${r}"
                                fi
                        else
                                echo -e "${m}[-] ${p}File ZIP '${m}${fz}${p}' tidak ditemukan.${r}"
                        fi
                else
                        echo -e "${m}[-] ${p}File ZIP tidak boleh kosong.${r}"
                fi
        done
}

# Fungsi untuk memilih jenis teknik
function mjt(){

        echo -e "${b}┌-----------------------------------------------┐${r}"
        echo -e "${b}│ [${m}Teknik serangan yang tersedia${b}]               │${r}"
	echo -e "${b}│-----------------------------------------------│${r}"
        echo -e "${b}├[${m}1${b}] ${p}Brute Force Attack${b}                         │${r}"
      	echo -e "${b}├[${m}2${b}] ${p}Dictionary Attack${b}                          │${r}"
        echo -e "${b}└-----------------------------------------------┘${r}"

        while true; do
		echo -e "${b}┌(${m}Fcrackzip${b})-[ ${p}Pilih teknik serangan ${b}]"
                read -p $'\e[1;34m└\e[1;31m# \e[1;37m' pts
                case "${pts}" in
                        1)
                                # Brute Force Attack 
                                echo -e "${h}[${p}+${h}] ${p}Teknik serangan yang dipilih '${h}Brute Force Attack${p}'${r}"
                                bfa
                                break
                                ;;
                        2)
                                # Dictionary Attack 
                                echo -e "${h}[${p}+${h}] ${p}Teknik serangan yang dipilih '${h}Dictionary Attack${p}'$r}"
                                da
                                break
                                ;;
                        *)
                                echo -e "${m}[${p}-$m}] ${p}Teknik serangan '${m}${pts}${p}' tidak tersedia.${r}"
                                ;;
                esac
        done
}

# Fungsi untuk memasukkan panjang minimal kata sandi
function mpmin(){
        while true; do
		echo -e "${b}┌(${m}Fcrackzip${b})-[ ${p}Masukkan panjang minimal kata sandi ${b}]"
                read -p $'\e[1;34m└\e[1;31m# \e[1;37m' pmin
                if [[ ! -z "${pmin}" ]]; then
                        if [[ "${pmin}" =~ ^[0-9]+$ ]]; then
                                echo -e "${h}[${p}+${h}] ${p}Panjang minimal kata sandi yang digunakan '${h}${pmin}${p}'${r}"
                                break
                        else
                                echo -e "${m}[${p}-${m}] ${p}Masukkan tidak valid. Harap masukkan angka.${r}"
                        fi
                else
                        echo -e "${m}[${p}-${m}] ${p}Panjang minimal kata sandi tidak boleh kosong.${r}"
                fi
        done
}

# Fungsi untuk memasukkan panjang maksimal kata sandi
function mpmaks(){
        while true; do
		echo -e "${b}┌(${m}Fcrackzip${b})-[ ${p}Masukkan panjang maksimal kata sandi ${b}]"
                read -p $'\e[1;34m└\e[1;31m# \e[1;37m' pmaks
                if [[ ! -z "${pmaks}" ]]; then
                        # Jika input yang dimasukkan berupa angka
                        if [[ "${pmaks}" =~ ^[0-9]+$ ]]; then
                                echo -e "${h}[${p}+${h}] ${p}Panjang maksimal kata sandi yang digunakan '${h}${pmin}${p}'${r}"
                                break
                        else
                                echo -e "${m}[${p}-${m}] ${p}Masukkan tidak valid. Harap masukkan angka.${r}"
                        fi
                else
                        echo -e "${m}[${p}-${m}] ${p}Panjang maksimal kata sandi tidak boleh kosong.${r}"
                fi
        done
}

# Fungsi untuk memilih jenis karakter
function mjk(){

        echo -e "${b}┌------------------------------------------------┐${r}"
        echo -e "${b}│ [ ${m}Jenis karakter yang tersedia ${b}]               │${r}"
	echo -e "${b}│------------------------------------------------│${r}"
	echo -e "${b}├[${m}1${b}] ${p}Huruf Kecil${b}                                 │${r}"
        echo -e "${b}├[${m}2${b}] ${p}Huruf Besar${b}                                 │${b}"
        echo -e "${b}├[${m}3${b}] ${p}Angka${b}                                       │${r}"
        echo -e "${b}├[${m}4${b}] ${p}Simbol${b}                                      │${r}"
        echo -e "${b}├[${m}5${b}] ${p}Huruf Kecil + Huruf Besar${b}                   │${r}"
        echo -e "${b}├[${m}6${b}] ${p}Huruf Kecil + Angka${b}                         │${r}"
        echo -e "${b}├[${m}7${b}] ${p}Huruf Kecil + Simbol${b}                        │${r}"
        echo -e "${b}├[${m}8${b}] ${p}Huruf Besar + Angka${b}                         │${r}"
        echo -e "${b}├[${m}9${b}] ${p}Huruf Besar + Simbol${b}                        │${r}"
        echo -e "${b}├[${m}10${b}] ${p}Angka + Simbol${b}                             │${r}"
        echo -e "${b}├[${m}11${b}] ${p}Huruf Kecil + Huruf Besar + Angka${b}          │${r}"
        echo -e "${b}├[${m}12${b}] ${p}Huruf Kecil + Huruf Besar + Simbol${b}         │${r}"
        echo -e "${b}├[${m}13${b}] ${p}Huruf Kecil + Angka + Simbol${b}               │${r}"
        echo -e "${b}├[${m}14${b}] ${p}Huruf Besar + Angka + Simbol${b}               │${r}"
        echo -e "${b}├[${m}15${b}] ${p}Huruf Kecil + Huruf Besar + Angka + Simbol${b} │${r}"
	echo -e "${b}└------------------------------------------------┘${r}"

        while true; do
		echo -e "${b}┌(${m}Fcrackzip${b})-[ ${p}Pilih jenis karakter ${b}]"
                read -p $'\e[1;34m└\e[1;31m# \e[1;37m' pjk
                case "${pjk}" in
                        1)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil${p}'${r}"
                                k="a"
                                break
                                ;;
                        2)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Besar${p}'${r}"
                                k="A"
                                break
                                ;;
                        3)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Angka${p}'${r}"
                                k="1"
                                break
                                ;;
                        4)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Simbol${p}'${r}"
                                k="!"
                                break
                                ;;
                        5)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil ${p}+ ${h}Huruf Besar${p}'${r}"
                                k="aA"
                                break
                                ;;
                        6)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil ${p}+ ${h}Angka${p}'${r}"
                                k="a1"
                                break
                                ;;
                        7)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil ${p}+ ${h}Simbol${p}'${r}"
                                k="a!"
                                break
                                ;;
                        8)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Besar ${p}+ ${h}Angka${p}'${r}"
                                k="A1"
                                break
                                ;;
                        9)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Besar ${p}+ ${h}Simbol${p}'${r}${r}"
                                k="A!"
                                break
                                ;;
                        10)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Angka ${p}+ ${h}Simbol${p}'${r}${r}"
                                k="1!"
                                break
                                ;;
                        11)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil ${p}+ ${h}Huruf Besar ${p}+ ${h}Angka${p}'${r}"
                                k="aA1"
                                break
                                ;;
                        12)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil ${p}+ ${h}Huruf Besar ${p}+ ${h}Simbol${p}'${r}"
                                k="aA!"
                                break
                                ;;
                        13)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil ${p}+ ${h}Angka ${p}+ ${h}Simbol${p}'${r}"
                                k="a1!"
                                break
                                ;;
                        14)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Besar ${p}+ ${h}Angka ${p}+ ${h}Simbol${p}'${r}"
                                k="A1!"
                                break
                                ;;
                        15)
                                echo -e "${h}[${p}+${h}] ${p}Jenis karakter yang dipilih '${h}Huruf Kecil + ${h}Huruf Besar + ${h}Angka + ${h}Simbol'"
                                k="aA1!"
                                break
                                ;;
                        *)
                                echo -e "${m}[${p}-${m}] ${p}Jenis karakter '${m}${pjk}${p}' tidak tersedia.${r}"
                                ;;
                esac
        done
}

# Fungsi untuk memasukkan file wordlist
function mfw(){
        while true; do
		echo -e "${b}┌(${m}Fcrackzip${b})-[ ${p}Masukkan nama file wordlist ${b}]"
                read -p $'\e[1;34m└\e[1;31m# \e[1;37m' fw
                if [[ ! -z "${fw}" ]]; then
                        if [[ -f "${fw}" ]]; then
                                echo -e "${h}[${p}+${h}] ${p}File wordlist '${h}${fw}${p}' ditemukan.${r}"
                                break
                        else
                                echo -e "${m}[${p}-${m}] ${p}File wordlist '${m}${fw}${p}' tidak ditemukan.${r}"
                        fi
                else
                        echo -e "${m}[${p}-${m}] ${p}File wordlist tidak boleh kosong.${r}"
                fi
        done
}

# Fungsi untuk teknik Brute Force Attack
function bfa(){
        mpmin # Memanggil fungsi memasukkan panjang minimal kata sandi
        mpmaks # Memanggil fungsi memasukkan panjang maksimal kata sandi
        mjk # Memanggil fungsi memilih jenis karakter
}

# Fungsi untuk teknik Dictionary Attack
function da(){
        mfw # Memanggil fungsi memasukkan file wordlist
}

# Fungsi untuk meng-crack kata sandi File ZIP menggunakan Fcrackzip
 function cfz(){
        # Teknik Brute Force Attack
        if [[ "${pts}" == "1" ]]; then
                kata_sandi=$(fcrackzip -u -b -c "${k}" -l "${pmin}"-"${pmaks}" "${fz}" | awk "NR==3 {print \$5}")
		if [[ ! -z "${kata_sandi}" ]]; then
			echo -e "${h}[${p}+${h}] ${p}Kata sandi ditemukan: '${h}${kata_sandi}${p}'${r}"
	                exit 0
		else
			echo -e "${m}[${p}-${m}] ${p}Kata sandi tidak ditemukan${r}"
			exit 1
		fi
        # Teknik Dictionary Attack
        elif [[ "${pts}" == "2" ]]; then
                kata_sandi_d=$(fcrackzip -u -D -p "${fw}" "${fz}" | awk "NR==3 {print \$5}")
		if [[ ! -z "${kata_sandi_d}" ]]; then
			echo -e "${h}[${p}+${h}] ${p}Kata sandi ditemukan: '${h}${kata_sandi}${p}'${r}"
			exit 0
		else
			echo -e "${m}[${p}-${m}] ${p}Kata sandi tidak ditemukan${r}"
			exit 1
		fi
        fi
}

# Fungsi utama Fcrackzip
function main(){
        mfz # Memanggil fungsi memasukkan file zip
        mjt # Memanggi fungsi memilih jenis teknik
        cfz # Memanggil fungsi meng-crack kata sandi file ZIP menggunakan Fcrackzip
}


main

