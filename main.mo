import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type Task = {
    id : Nat;
    title : Text;
    description : Text;
    status : Text;
    createdAt : Time.Time;
    updatedAt : Time.Time;
  };

  type Project = {
    id : Nat;
    name : Text;
    tasks : Buffer.Buffer<Task>;
  };

  var projects = Buffer.Buffer<Project>(0);

  public func createProject(name : Text) : async Nat {
    let projectId = projects.size();
    let newProject : Project = {
      id = projectId;
      name = name;
      tasks = Buffer.Buffer<Task>(0);
    };
    projects.add(newProject);
    projectId;
  };

  public func addTask(projectId : Nat, title : Text, description : Text) : async Nat {
    let project = projects.get(projectId);
    let taskId = project.tasks.size();
    let newTask : Task = {
      id = taskId;
      title = title;
      description = description;
      status = "To Do";
      createdAt = Time.now();
      updatedAt = Time.now();
    };
    project.tasks.add(newTask);
    taskId;
  };

  public query func getProjectDetails(projectId : Nat) : async {id : Nat; name : Text; tasks : [Task]} {
    let project = projects.get(projectId);
    {
      id = project.id;
      name = project.name;
      tasks = Buffer.toArray(project.tasks);
    };
  };

  public func updateTaskStatus(projectId : Nat, taskId : Nat, newStatus : Text) : async () {
    let project = projects.get(projectId);
    var task = project.tasks.get(taskId);
    task := {
      id = task.id;
      title = task.title;
      description = task.description;
      status = newStatus;
      createdAt = task.createdAt;
      updatedAt = Time.now();
    };
    project.tasks.put(taskId, task);
  };

  public query func getProjectStatistics(projectId : Nat) : async {
    totalTasks : Nat;
    completedTasks : Nat;
    inProgressTasks : Nat;
  } {
    let project = projects.get(projectId);
    var totalTasks = 0;
    var completedTasks = 0;
    var inProgressTasks = 0;

    for (task in project.tasks.vals()) {
      totalTasks += 1;
      switch (task.status) {
        case "Completed" { completedTasks += 1 };
        case "In Progress" { inProgressTasks += 1 };
        case _ {};
      };
    };

    {
      totalTasks = totalTasks;
      completedTasks = completedTasks;
      inProgressTasks = inProgressTasks;
    };
  };
};