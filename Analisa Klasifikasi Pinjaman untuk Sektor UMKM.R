**Klasifikasi Pinjaman untuk Sektor UMKM**

-> Membaca Data External
Info: materi telah diperbarui pada tanggal 19 Agustus 2021, pastikan kembali kode yang telah ditulis disesuaikan dengan bagian Lesson.
Hal yang pertama dilakukan adalah membaca dataset yang telah dipersiapkan. Dengan menggunakan fungsi bawaan R bacalah dataset yang berformat csv tersebut yang bernama "https://storage.googleapis.com/dqlab-dataset/project.csv".
==> Code Editor R :
#Dataset diperoleh dari DQLab
data = read.csv("https://storage.googleapis.com/dqlab-dataset/project.csv")

-> Inspeksi data
==> Code Editor R :
# Enam baris teratas data
head(data)

# Tampilkan tipe data setiap kolomnya
str(data)

-> Statistik Dekriptif data
Info: materi telah diperbarui pada tanggal 19 Agustus 2021, pastikan kembali kode yang telah ditulis disesuaikan dengan bagian Lesson.
Melalui R kita dapat menampilkan statistik deskriptif pada data yang dimiliki. Jika diinginkan lebih spesifik maka dapat dilakukan pada kolom tertentu pada tabel data yang kita punya. Tentunya kita dapat menggunakan accessor $ untuk memilih kolom yang diinginkan dari data. Diperhatikan sintak berikut:
summary(data$OSL)
==> Code Editor R :
summary(data)

-> Menghapus Kolom
Info: materi telah diperbarui pada tanggal 19 Agustus 2021, pastikan kembali kode yang telah ditulis disesuaikan dengan bagian Lesson.
Pada data yang kamu miliki, sebenarnya kamu tidak memerlukan nama pelanggan untuk diberikan rekomendasi. Atau dengan kata lain penanda pelanggan untuk diberikan rekomendasi cukup dengan melihat no_kontrak pelanggan itu saja.
Tugas:
Hapuslah kolom "X" dan nama nasabah pada data yang kamu miliki dan cetak kembali nama kolom yang tersedia pada data
==> Code Editor R :
data_reduce = data[-c(1,2)]
colnames(data_reduce)

-> Konversi Data
Info: materi telah diperbarui pada tanggal 19 Agustus 2021, pastikan kembali kode yang telah ditulis disesuaikan dengan bagian Lesson.
Seperti yang diketahui ketika data ditarik dari suatu sumber terkadang ada kondisi tipe data tidak dengan tepat direpresentasikan. Misalkan semua record/baris pada suatu kolom berisi seharusnya data numerik akan tetapi disajikan didalam suatu karakter angka.
R sendiri memiliki fungsi sapply yang dapat digunakan untuk mengkoversi tipe data. Dalam hal ini fungsi sapply menerima input/argumen fungsi berupa list, vector, atau data frame dan mengembalikan/menghasilkan output berupa vector atau matrix.
Cobalah untuk meninjau kembali kolom "PRODUK", "PYD", "TENOR", dan "OSL" apakah perlu dikonversikan menjadi bertipe numerik atau tidak.
Jika tidak, kamu dapat menjawab dengan mengetikkan FALSE di code editor.
Tetapi, jika perlu dirubah maka ketikkanlah perintah berikut:
data_reduce[, 8:11] = sapply(data_reduce[, 8:11], as.numeric)
==> Code Editor R :
FALSE

-> Pemilihan data kategori
Info: materi telah diperbarui pada tanggal 19 Agustus 2021, pastikan kembali kode yang telah ditulis disesuaikan dengan bagian Lesson.
Tentu saja kamu menyadari bahwa data yang dimiliki ada yang bersifat kategori. Data kategori dapat dipilih melalui kolom-kolom "KONDISI_USAHA", "KONDISI_JAMINAN", "REKOMENDASI_TINDAK_LANJUT". Ketikkanlah potongan kode berikut:
Ubah kolom "REKOMENDASI_TINDAK_LANJUT" sebagai faktor (gunakan as.factor)
Gunakan uji chi-square dapat digunakan untuk melihat hubungan antar variabel kategorik berikut:
•	"KONDISI_USAHA" dengan "REKOMENDASI_TINDAK_LANJUT", dan
•	"KONDISI_JAMINAN" dengan "REKOMENDASI_TINDAK_LANJUT"
==> Code Editor R :
#Pemilihan data kategori
data_kategorik = data_reduce[,c("KONDISI_USAHA", "KONDISI_JAMINAN", "REKOMENDASI_TINDAK_LANJUT")]

data_reduce$REKOMENDASI_TINDAK_LANJUT = as.factor(data_reduce$REKOMENDASI_TINDAK_LANJUT)

chisq.test(data_kategorik$KONDISI_USAHA, data_kategorik$REKOMENDASI_TINDAK_LANJUT)

chisq.test(data_kategorik$KONDISI_JAMINAN, data_kategorik$REKOMENDASI_TINDAK_LANJUT)

-> Korelasi antar variabel data
==> Code Editor R :
library(corrplot)
library(ggcorrplot)

M = data_reduce[,8:11]

# Library corrplot
# -- Pearson correlation
par(mfrow=c(2,2))
corrplot(cor(M), type="upper", order="hclust")
corrplot(cor(M), method="square", type="upper")
corrplot(cor(M), method="number", type="lower")
corrplot(cor(M), method="ellipse")

# -- Kendall correlation
par(mfrow=c(2,2))
corrplot(cor(M, method="kendall"), type="upper", order="hclust")
corrplot(cor(M, method="kendall"), method="square", type="upper")
corrplot(cor(M, method="kendall"), method="number", type="lower")
corrplot(cor(M, method="kendall"), method="ellipse")

# Library ggcorrplot
corr = round(cor(M), 1) # Pearson correlation
ggcorrplot(round(cor(M), 1),
             hc.order = TRUE,
             type = "lower",
             lab = TRUE,
             lab_size = 3,
             method="circle",
             colors = c("tomato2", "white", "springgreen3"),
             title="Correlogram of Data Nasabah",
             ggtheme=theme_bw)

-> Pemilihan fitur/independent variabel/input
Dalam melakukan pemodelan tentu kita perlu meninjau variabel-variabel apa saja yang berpengaruh pada model kita, khususnya pada klasifikasi. Pada kesempatan ini kita menggunakan model Regresi Multinomial.
Lalu bagaimana menentukan variabel apa saja yang berpengaruh tersebut?
Ada banyak alternatif, salah satunya ialah Information Gain. Melalui information gain diambil nilai importance variabel yang lebih dari 0.02 (kamu dapat eksplorasi apa yang terjadi apabila kita mengambil nilai yang kurang dari 0.02).
Berikut hasil dari information gain:
                attr_importance
KONDISI_JAMINAN     0.038889946
STATUS              0.109539204
KEWAJIBAN           0.002414449
OSL                 0.006693011
KOLEKTIBILITAS      0.084934084

Lakukanlah sintak berikut untuk memilih kolom-kolom yang akan diproses:
colnames(data_reduce)
data_select =
data_reduce[,c("KARAKTER","KONDISI_USAHA","KONDISI_JAMINAN","STATUS","KEWAJIBAN","OSL","KOLEKTIBILITAS","REKOMENDASI_TINDAK_LANJUT")]
Jika pada data terdapat NA value, nilai tersebut dapat pula untuk dipangkas. Hapuslah nilai NA tersebut. 
Code Editor R :
#Pemilihan fitur/independent variabel/input
colnames(data_reduce)
data_select =
data_reduce[,c("KARAKTER","KONDISI_USAHA","KONDISI_JAMINAN","STATUS","KEWAJIBAN","OSL","KOLEKTIBILITAS","REKOMENDASI_TINDAK_LANJUT")]

#data_select
data_non_na = na.omit(data_select)

-> Transformasi Data
Untuk memberikan performa model yang baik,  maka pada data kita perlu dilakukan treatment tertentu, misalnya dilakukan scalling atau dilakukan pengelompokan data atau disebut juga bucketing.
==> Code Editor R :
#Transformasi Data
data_select_new = data_select
data_select_new$KEWAJIBAN = scale(data_select_new$KEWAJIBAN)[, 1]
data_select_new$OSL = scale(data_select_new$OSL)[, 1]
data_select_new$KEWAJIBAN = cut(data_select_new$KEWAJIBAN, breaks = c(-0.354107,5,15,30))
data_select_new$KEWAJIBAN = as.factor(data_select_new$KEWAJIBAN)
data_select_new$OSL = cut(data_select_new$OSL, breaks = c(-0.60383,3,10,15))
data_select_new$OSL = as.factor(data_select_new$OSL)
data_select_new = na.omit(data_select_new)

-> Training Data
Sebelum masuk pada pemodelan, kita perlu memisahkan data kita menjadi training dan testing (ada pula yang membaginya menjadi training, testing, dan validasi).
Tujuan dari pemisahan data ini ialah untuk melihat kemampuan model kita untuk melakukan prediksi sebagaimana tujuan dari pemodelan kita.
Lakukanlah perintah berikut :
index = createDataPartition(data_select_new$REKOMENDASI_TINDAK_LANJUT, p = .95, list = FALSE)
==> Code Editor R :
#Training Data
library(caret)
index = createDataPartition(data_select_new$REKOMENDASI_TINDAK_LANJUT, p = .95, list = FALSE)
train = data_select_new[index,]
test = data_select_new[-index,]

-> Pemodelan/Modelling
Sekarang kita siap untuk masuk pada pemodelan.
Ingat bahwa kita menggunakan Model Regresi Multinomial, dimana kita perlu menentukan referensi dari kelas target.
Referensi kelas target ini ialah kelas yang memiliki jumlah anggota terbanyak.

==> Code Editor R :
#Pemodelan/Modelling
train2 = train
# Setting the reference
train2$REKOMENDASI_TINDAK_LANJUT = relevel(train2$REKOMENDASI_TINDAK_LANJUT, ref = "Angsuran Biasa")
#training the model
require(nnet)
# Training the multinominal model
multinom_model = multinom(REKOMENDASI_TINDAK_LANJUT ~ ., data =  train2)

# Checking the model
summary(multinom_model)
#converting the coefficients to odds by taking the exponential of the coefficients.
exp(coef(multinom_model))
head(round(fitted(multinom_model),2))
# Predicting the values for train dataset
train2$ClassPredicted = predict(multinom_model, newdata = train2, "class")
train_prob = predict(multinom_model, newdata = train2, "probs")
df = train_prob
df$max = apply(df,1,max)
train2$score = df$max
test_prob = predict(multinom_model, newdata = test, "probs")
df2 = test_prob
df2$max = apply(df2,1, max)

# Building classification table
tab_train = table(train2$REKOMENDASI_TINDAK_LANJUT, train2$ClassPredicted)
round((sum(diag(tab_train))/sum(tab_train))*100,4)
test$ClassPredicted = predict(multinom_model, newdata = test, "class")
test$score = df2$max
tab_test  = table(test$REKOMENDASI_TINDAK_LANJUT, test$ClassPredicted)
round((sum(diag(tab_test))/sum(tab_test))*100,4)
