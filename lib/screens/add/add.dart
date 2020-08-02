import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/upload_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:grad_project/utils/text_styles.dart';

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'New Post',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: Container(
        child: AddBody(h, w),
      ),
    );
  }
}

class AddBody extends StatefulWidget {
  final double w;
  final double h;
  AddBody(this.h, this.w);

  @override
  _AddBodyState createState() => _AddBodyState();
}

class _AddBodyState extends State<AddBody> {
  List<String> categories = [
    'Music',
    'Photography',
    'Graphic Design',
    'Sports',
    'Crafts',
    'Acting',
  ];
  String selectedCategory = 'Music';
  List<File> pickedFiles = [];
  List<String> tags = [];
  List<List<String>> coAuthors = [];
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool isUploading = false;

  @override
  void dispose() {
    print('elimnating add screen');
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: widget.w / 20, right: widget.w / 15, left: widget.w / 15),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((item) => _buildCategoryItem(item)).toList(),
              ),
            ),
            _titleTextField(title),
            _descriptionField(description),
            _fileChooser(),
            _addTags(context),
            _addCoAuthors(context),
            _buttons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String categoryName) {
    bool isSelectedItem;
    categoryName == selectedCategory
        ? isSelectedItem = true
        : isSelectedItem = false;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryName;
        });
        print(selectedCategory);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
          border: Border.all(color: isSelectedItem ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          categoryName,
          style: TextStyle(color: isSelectedItem ? Colors.blue : Colors.grey),
        ),
      ),
    );
  }

  Widget _titleTextField(TextEditingController title) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextField(
        controller: title,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Title',
          hintStyle: AppTextStyles.addScreenSectionTitle,
        ),
      ),
    );
  }

  Widget _descriptionField(TextEditingController description) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextField(
        controller: description,
        maxLines: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Description',
          hintStyle: AppTextStyles.addScreenSectionTitle,
        ),
      ),
    );
  }

  Widget _fileChooser() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Choose File',
                  style: AppTextStyles.addScreenSectionTitle,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue,
                onPressed: () async {
                  FileType type;
                  if (selectedCategory == 'Music') {
                    type = FileType.AUDIO
                    ;
                  } else {
                    type = FileType.IMAGE;
                  }

                  List<File> x = await FilePicker.getMultiFile(type: type);

                  if (x != null) {
                    setState(() {
                      pickedFiles.addAll(x);
                      pickedFiles = pickedFiles.toSet().toList();
                    });
                  }

                  print(pickedFiles);
                },
              ),
            ],
          ),
          Container(
            //height: widget.h / 6,
            color: Colors.grey.shade200,
            child: Column(
              //shrinkWrap: true,
              children: pickedFiles.map((f) {
                return ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text(basename(f.path)),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        pickedFiles.remove(f);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addTags(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Add tags',
                  style: AppTextStyles.addScreenSectionTitle,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue,
                onPressed: () async {
                  var tag = await showDialog(
                      context: context,
                      builder: (context) {
                        String tag;
                        return AlertDialog(
                          title: Text('Add tag'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.pop(context, tag);
                              },
                            ),
                          ],
                          content: TextField(
                            onChanged: (val) {
                              tag = val;
                            },
                          ),
                        );
                      });
                  print(tag);

                  if (tag != null) {
                    setState(() {
                      tags.add(tag);
                    });
                  }
                },
              ),
            ],
          ),
          Container(
            //height: widget.h / 6,
            color: Colors.grey.shade200,
            child: Column(
                //shrinkWrap: true,
                children: tags.map((t) {
              return ListTile(
                title: Text(t),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      tags.remove(t);
                    });
                  },
                ),
              );
            }).toList()),
          ),
        ],
      ),
    );
  }

  Widget _addCoAuthors(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Co-Authors',
                  style: AppTextStyles.addScreenSectionTitle,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue,
                onPressed: () async {
                  var users = await showDialog(
                    context: context,
                    builder: (context) {
                      return CoAuthorsPopup();
                    },
                  );
                  Provider.of<Uploader>(context, listen: false).clearSearch();
                  if (users != null) {
                    setState(() {
                      coAuthors = users;
                    });
                    print(users.runtimeType);
                  }
                },
              ),
            ],
          ),
          Container(
            color: Colors.grey.shade200,
            child: Column(
              children: coAuthors.map((u) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(u[2]),
                  ),
                  title: Text(u[0]),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        coAuthors.remove(u);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return isUploading ? Center(child: CircularProgressIndicator(),) : Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FlatButton(
                color: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () async {
                  String t = title.value.text;
                  String d = description.value.text;

                  if (t.isEmpty) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Title cant be empty'),
                      ),
                    );
                    return;
                  }

                  if (pickedFiles.isEmpty) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please choose a file'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    isUploading = true;
                  });

                  var msg = await Provider.of<Uploader>(context).uploadPost(
                    files: pickedFiles,
                    category: selectedCategory,
                    coAuthorData: coAuthors,
                    tags: tags,
                    postTitle: t,
                    postDescription: d,
                  );

                  setState(() {
                    isUploading = false;
                  });

                  if (msg != null) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      ),
                    );
                  }

                  print('ya slam');
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FlatButton(
                color: Colors.red,
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoAuthorsPopup extends StatefulWidget {
  @override
  _CoAuthorsPopupState createState() => _CoAuthorsPopupState();
}

class _CoAuthorsPopupState extends State<CoAuthorsPopup> {
  String searchKeyword;
  List<List<String>> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    var searchResult = Provider.of<Uploader>(context).getSearchResults;
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (val) {
                searchKeyword = val;
              },
              decoration: InputDecoration.collapsed(
                  hintText: 'Search for users...',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  )),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Provider.of<Uploader>(context).searchForUser(searchKeyword);
            },
          ),
        ],
      ),
      content: Container(
        width: 500,
        height: 300,
        child: ListView(
          children: searchResult.map((u) {
            return _buildResultListItem(u);
          }).toList(),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Add users'),
          onPressed: () {
            Navigator.pop(context, selectedUsers);
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildResultListItem(List<String> userData) {
    bool isSelected = false;

    selectedUsers.forEach((u) {
      if (u[1] == userData[1]) {
        isSelected = true;
      }
    });

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userData[2]),
      ),
      title: Text(userData[0]),
      selected: isSelected,
      trailing: isSelected ? Icon(Icons.check) : null,
      onLongPress: () {
        setState(() {
          if (isSelected) {
            int deleteIndex;
            selectedUsers.asMap().forEach((index, u) {
              if (u[1] == userData[1]) {
                deleteIndex = index;
              }
            });
            selectedUsers.removeAt(deleteIndex);
          } else {
            selectedUsers.add(userData);
          }

          print('Selected users in dialog are');
          print(selectedUsers);
        });
      },
    );
  }
}
