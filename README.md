Vagrant meteor-gazelle Build
============================
Once set up, the gazelle source files will be present in `src/`, which is shared to `/var/www/` on the machine.
Port 3000 will be forwarded to host port 3000.
Port 8080 will be forwarded to host port 8080 for debugging.
You can access the virtualbox's web server with the url localhost:3000

Prerequisites
-------------
* Vagrant is installed

Usage
-----
1.  Clone this repo.
    * Download the base box from here: https://www.dropbox.com/s/3r6d9c8x5dvibw6/Gazelle.box?dl=0 and put it inside the cloned repo.
2.  Navigate to the repo's location and run the command `vagrant box add 'Gazelle' 'Gazelle.box'`
2.  Boot the box from the repo directory: `vagrant up`. Provisioning will take a little while.
3.  Navigate to `/var/www` on the box, and run the command `meteor run --settings settings.json`. It will download and run meteor. You can then navigate
    to localhost:3000 to see the running site. 

Useful Commands
---------------
* `vagrant up`- Resume/boot the vm
* `vagrant suspend`- Save the vm's state
* `vagrant halt`- Shutdown the vm
* `vagrant destroy`- Remove the box's hard drive. This preserves the .box file, so running `vagrant up` will import, boot and re-provision the box. This is essentially
starting over.
* `vagrant ssh`- SSH into the vm after it's been booted

Notes
-----
* You can change the hostname by editing the line `config.vm.hostname` in the Vagrantfile.
* The directory `/var/www/.meteor/local/db` is symlinked to `/var/db`. If you delete either of those, be sure the symlink is up to date.
* You may use another base box if you wish. However, the setup script is intended for the one linked above. There's no guarentees it will work.
* All vagrant commands must be ran from the repo's directory, or any subdirectories within the repo.
* This was tested and written on Linux Mint 17.

Contributing
------------
Fork the repository, make your changes, and send a pull request.
