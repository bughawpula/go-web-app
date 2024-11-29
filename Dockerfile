#START OF BASE STAGE
#to set alias name base, we use golang base image instead of OS to become distroless image for lesser image size
FROM golang:1.22.5 as base    

#the image pwd where to put all copied folders/files from host
WORKDIR /app

#to copy from host this go.mod file to install any app dependencies versions to be use for this image
COPY go.mod . 

#actual command to install app dependencies based on contents of go.mod file
RUN go mod download 

#means to copy all folders/files under this host pwd going to this image workdir /app
COPY . .

#to build the go app as binary file under /app directory
RUN go build -o abishek .

#to become distroless image which reduce the image size 
#END OF BASE STAGE

#FINAL STAGE TO BECOME DISTROLESS IMAGE
#gcr is one of the popular artifact repo to implement distroless image
FROM gcr.io/distroless/base

#to copy our base image (alias name) which is the whole base stage above going to default or current image directory "."
COPY --from=base /app/abishek .

#same idea as above but to copy the static file going to this ./static folder inside this distroless image
COPY --from=base /app/static ./static

#to be use by our go app
EXPOSE 8080

#to run the go application 
CMD [ "./abishek" ]




