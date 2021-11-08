# cm-qa-test-bed-vps
qa test bed with jenkins, selenoid, selenoid-ui on a VPS

## how

I've made it to roll out the test bed on digital ocean, but it should work on any VPS I think.

1. create a droplet (4Gbytes of RAM will be a good idea)
2. log in to your VPS (droplet, whatever) as root
3. `git clone https://github.com/cheshi-mantu/cm-qa-test-bed-vps.git`
4. `cd cm-qa-test-bed-vps`
5. `chmod +x infra.sh`
6. `./infra.sh`

During the execution script will ask you for new root's password and we'll create a new user to work with (you remember that working under root is not secure blah-blah-blah).