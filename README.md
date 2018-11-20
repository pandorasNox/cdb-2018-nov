# cdb-2018-nov
coding berlin 2018 nov

## init react

``` bash
cd src/react

docker run -it --rm -v $(pwd):/temp -u "$(id -u):$(id -g)" create-react-app /temp

make node-cli
yarn global add elm
rm -rf node_modules/
yarn install

```
