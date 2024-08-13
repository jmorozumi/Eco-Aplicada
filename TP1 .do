clear
global main "/Users/zowi/Documents/GitHub/Eco-Aplicada/PS1"
global input "$main/input"
global output "$main/output"

use "$input/data_russia.dta", clear

*Para limpiar la base de datos vamos a ver que tipode formato tiene las variables
describe

preserve

gen sex_limpia =.
replace sex_limpia = 1 if sex=="female"
replace sex_limpia = 0 if sex=="male"
drop sex

gen obese_limpia =.
replace obese_limpia = 1 if obese=="This person is obese"
replace obese_limpia = 0 if obese=="This person is not obese"
drop obese

gen smokes_limpia =.
replace smokes_limpia = 1 if smokes=="Smokes"
replace smokes_limpia = 0 if smokes=="0"
drop smokes

split hipsiz, parse("circumference ")
drop hipsiz1
drop hipsiz
replace hipsiz2 = "" if hipsiz2 == ","
replace hipsiz2 = subinstr(hipsiz2, ",", ".", .)

split totexpr, parse("expenditures ")
drop totexpr1
drop totexpr
replace totexpr2 = "" if totexpr2 == ","
replace totexpr2 = subinstr(totexpr2, ",", ".", .)

replace tincm_r = "" if tincm_r == ","
replace tincm_r = subinstr(tincm_r, ",", ".", .)


foreach var of varlist econrk powrnk resprk satlif geo wtchng evalhl operat {
tab `var'
}

*
foreach var of varlist econrk powrnk resprk satlif geo {
replace `var' = "." if `var' == ".b"
replace `var' = "." if `var' == ".d"
replace `var' = "." if `var' == ".c"
replace `var' = "1" if `var' == "one"
replace `var' = "2" if `var' == "two"
replace `var' = "3" if `var' == "three"
replace `var' = "4" if `var' == "four"
replace `var' = "5" if `var' == "five"
}

foreach var of varlist wtchng evalhl operat {
replace `var' = "." if `var' == ".b"
replace `var' = "." if `var' == ".d"
replace `var' = "." if `var' == ".c"
replace `var' = "1" if `var' == "one"
replace `var' = "2" if `var' == "two"
replace `var' = "3" if `var' == "three"
replace `var' = "4" if `var' == "four"
replace `var' = "5" if `var' == "five"
}

foreach var of varlist hattac htself {
replace `var' = "." if `var' == ".b"
replace `var' = "." if `var' == ".d"
replace `var' = "." if `var' == ".c"
replace `var' = "1" if `var' == "one"
replace `var' = "2" if `var' == "two"
replace `var' = "3" if `var' == "three"
replace `var' = "4" if `var' == "four"
replace `var' = "5" if `var' == "five"
}


destring, replace

*lista de las variables
ds
* Calcula el porcentaje de valores faltantes para cada variable
* Verifica si el porcentaje de valores faltantes es mayor al 5%
foreach var of varlist * {
    count if missing(`var')
    local missing = r(N)
    local total = _N
    local percent_missing = 100 * `missing' / `total'
	
    if `percent_missing' > 5 {
        display "`var' tiene más del 5% de valores faltantes: " `percent_missing' "%"
    }
}

*Este código hace lo siguiente:

*ds: lista todas las variables en el dataset.
*foreach var of varlist *: recorre cada variable en la lista de variables.
*count if missing(\var')`: cuenta cuántos valores faltantes tiene la variable actual.
*local missing = r(N): guarda el número de valores faltantes en una macro local.
*local total = _N: guarda el número total de observaciones en otra macro local.
*local percent_missing = 100 * \missing' / ⁠ total' ⁠: calcula el porcentaje de valores faltantes.
*if \percent_missing' > 5`: verifica si el porcentaje es mayor al 5%.
*display "var' tiene más del 5% de valores faltantes: " ⁠ percent_missing' "%" ⁠: muestra un mensaje si la variable tiene más del 5% de valores faltantes.*


*Sacamoslos income negativos
replace tincm_r = . if tincm_r<0
replace totexpr2 = . if totexpr2<0

replace totexpr2 = . if totexpr2 > tincm_r
