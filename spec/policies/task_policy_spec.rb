require 'spec_helper'

describe TaskPolicy do

  #let(:owner) { create(:user) }
  #let(:non_owner) { create(:user, username: 'jane') }
  #let(:editor) { create(:editor, username: 'eddy') }
  #let(:task) { create(:task_with_owner, user: owner) }
  
  before(:each) do
    @owner = build_stubbed(:user)
    @non_owner = build_stubbed(:user)
    @task = build_stubbed(:task)
    @role = build_stubbed_task_with_owner(@owner, @task)
    @editor = build_stubbed(:editor)
    build_stubbed_task_editor(@editor)
  end

  context "for the task owner" do
    subject { TaskPolicy.new(@owner, @task) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should_not permit(:destroy) }
  end
  
  context "for a task non-owner" do
    subject { TaskPolicy.new(@non_owner, @task) }

    it { should permit(:create) }
    it { should permit(:new) }
    it { should permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:edit) }
    it { should_not permit(:destroy) }
  end

  context "for an editor" do
    subject { TaskPolicy.new(@editor, @task) }

    it { should permit(:show)    }
    it { should permit(:create)    }
    it { should permit(:new)    }
    it { should permit(:update)    }
    it { should permit(:edit)    }
    it { should permit(:destroy)    }
    
  end
end
